# encoding: utf-8

require 'nokogiri'
require 'openssl'
require 'open-uri'
require 'kconv'
require 'uri'
require 'bundler/setup'
require 'extractcontent'
require 'RMagick'

class WebpageController < ApplicationController

  #定数定義
  BLANK = ""
  THRESHOLD_ALL = 20000
  THRESHOLD_SIDE = 100
  WIDTH  = 80
  HEIGHT = 80

  def add
    if signed_in?
      @user_id = "#{params[:id]}";
      @msg = "#{params[:msg]}";
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end
  
  def add_confirm
    if signed_in?
      @user_id = "#{params[:id]}";
      @url = "#{params[:url]}";
      @title = returnTitle(@url)
      if @title == nil
        @msg = "Please check URL."
        redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
      end
      article = Article.find_by_url(@url);
 
      if article != nil then
        @summary_num = article.summaries.count(:all)
        @article_id = article.id
      end

    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_add_history_for_chrome_extension
    if signed_in?
      user_id = getLoginUser.id;
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html' and return
      end
      article = Article.find_by_url(@url);
      if article != nil then
        user_article = article.user_articles.find_by_user_id(user_id);
        if user_article != nil then 
          #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、article.idを返却する
          render :text => article.id and return
        else
          render :text => BLANK and return
        end
      else
        render :text => BLANK and return
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_current_user_name_for_chrome_extension
    if signed_in?
      render :text => get_current_user_name and return
    else
      render :text => BLANK and return
    end
  end

  #TODO 画面からURL直打ちの回避
  def add_for_chrome_extension
    if signed_in?
      user_id = getLoginUser.id;
      @prof_image =  getLoginUser.prof_image;
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html' and return
      end
      article = Article.find_by_url(@url);
      if article != nil then
        @thumbnail = article.thumbnail;
        @contents_preview = article.contents_preview;
      	user_article = article.user_articles.find_by_user_id(user_id);
      	if user_article != nil then
      		render :text => article.id and return
      	else
      		user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
      		if user_article.save
            article.addStrength
      			render :text => article.id and return
      		end
      	end
      else

        @thumbnail = getThumbnailfromURL(@url);
        @contents_preview = getContentsPreviewfromURL(@url);

        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:url], :title => title, :contents_preview => @contents_preview[0, 200], :category_id =>"001", :thumbnail => @thumbnail);
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
          if user_article.save
            article.addStrength
            render :text => article.id and return
          end
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  def add_complete
  	if signed_in?
      user_id = getLoginUser.id;
      @prof_image =  getLoginUser.prof_image;
      @url = "#{params[:url]}";
      @title = "#{params[:title]}";
      article = Article.find_by_url(@url);
      if article != nil then
        @article_id = article.id;
        @thumbnail = article.thumbnail;
        @contents_preview = article.contents_preview;
        user_article = article.user_articles.find_by_user_id(user_id);
        if user_article != nil then 
          #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、エラーメッセージを表示する
          @msg = "Already registered."  and return
        else
          #同じURLの情報は存在するが、ユーザーが登録していない場合、r010のみinsertする
          user_article = UserArticle.new(:user_id => user_id, :article_id => @article_id, :read_flg => false);
          if user_article.save
            article.addStrength
            @msg = "Completed." and return
          end
        end
      else

        @thumbnail = getThumbnailfromURL(@url);
        @contents_preview = getContentsPreviewfromURL(@url);

        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:url], :title => @title, :contents_preview => @contents_preview[0, 200], :category_id =>"001", :thumbnail => @thumbnail);
        if article.save
          @article_id = article.id;
          user_article = UserArticle.new(:user_id => user_id, :article_id => @article_id, :read_flg => false);
          if user_article.save
              article.addStrength
              @msg = "Completed." and return
          end
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end
  
  #指定されたurlのタイトルを返却するメソッド
  def returnTitle(url)
    begin
=begin
      charset = nil;
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        charset = f.charset;
        f.read;
      end
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8");
=end

      doc = Nokogiri::HTML.parse(open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE));
      if doc.title != nil && doc.title != BLANK
        return doc.title;
      else
      	#タイトルが取得出来ない時はホスト名をタイトルに設定する
        return URI.parse(url).host
      end
    rescue => e
      logger.error("error :#{e}")
      return nil;
    end
  end

  #指定されたURLで使用されている画像を抜き出すメソッド
  #TODO 大きさのみで判定している
  def getThumbnailfromURL(url)
    begin
=begin
      charset = nil;
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        charset = f.charset;
        f.read;
      end
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8");
=end
      doc = Nokogiri::HTML.parse(open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE));
      doc.xpath("//img[starts-with(@src, 'http://')]").each{|img|
        image = Magick::ImageList.new(img['src'])
        columns = image.columns 
        rows = image.rows
        #閾値を超える最初の画像を象徴的な画像として返却する
        if columns.to_i > THRESHOLD_SIDE and rows.to_i > THRESHOLD_SIDE and (columns.to_i*rows.to_i) > THRESHOLD_ALL
          return img['src']
            break;
        end
      }
      return "no_image.png"
    rescue => e
      logger.error("error :#{e}")
      return "no_image.png"
    end
  end

  #指定されたURLの本文を抜き出すメソッド
  def getContentsPreviewfromURL(url)
    begin
      contents_preview = ""
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        f.read;
      end
        html = html.force_encoding("UTF-8")
        html = html.encode("UTF-8", "UTF-8")
        contents_preview, title = ExtractContent.analyse(html)
        return contents_preview
        # logger.debug("content_preview : #{contents_preview}")
    rescue => e
      # TODO : enable to handle "ArgumentError - invalid byte sequence in UTF-8:"
      logger.error("error :#{e}")
      return "本文が取得出来ませんでした。"
    end
  end
end
