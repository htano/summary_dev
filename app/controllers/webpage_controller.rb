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
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html' and return
      end
      article = Article.find_by_url(@url);
      if article != nil then
      	user_article = article.user_articles.find_by_user_id(user_id);
      	if user_article != nil then
      		render :text => article.id and return
      	else
      		user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
      		if user_article.save
            article.add_strength
      			render :text => article.id and return
      		end
      	end
      else

        image = getImagefromURL(@url);

        contents_preview = ""
        open(@url) do |io|
          html = io.read
          begin
            html = html.force_encoding("UTF-8")
            html = html.encode("UTF-8", "UTF-8")
            contents_preview, title = ExtractContent.analyse(html)
            # logger.debug("content_preview : #{contents_preview}")
          rescue => e
            # TODO : enable to handle "ArgumentError - invalid byte sequence in UTF-8:"
            logger.error("error :#{e}")
          end
        end
        #logger.debug("preview : #{contents_preview}}")

        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        #article = Article.new(:url => params[:url], :title => title, :contents_preview => contents_preview[0, 200], :category_id =>"001");
        article = Article.new(:url => params[:url], :title => title, :contents_preview => contents_preview[0, 200], :category_id =>"001", :image => image.to_blob);
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
          if user_article.save
            article.add_strength
            render :text => article.id and return
          end
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  def delete
    @aid = params[:article_id]
    user_article = getLoginUser.user_articles.find_by_article_id(@aid)
    if user_article
      Article.find(@aid).remove_strength(getLoginUser.id)
      user_article.destroy
      render :text => "OK"
    else
      render :text => "NG"
    end
  end

  def mark_as_read
    @msg = "NG"
    @aid = params[:article_id]
    @user_article = getLoginUser.user_articles.find_by_article_id(@aid)
    if @user_article
      if @user_article.read_flg
        @user_article.read_flg = false
      else
        @user_article.read_flg = true
      end
      if @user_article.save
        if @user_article.read_flg
          @msg = "mark_as_read"
        else
          @msg = "mark_as_unread"
        end
      end
    end
    render :text => @msg
  end

  def add
  	if signed_in?
      user_id = getLoginUser.id;
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        @msg = "指定されたURLは存在しません。URLを確認して下さい。" and return
      end
      article = Article.find_by_url(@url);
      if article != nil then
        user_article = article.user_articles.find_by_user_id(user_id);
        if user_article != nil then 
          #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、エラーメッセージを表示する
          @msg = "登録済みです。"  and return
        else
          #同じURLの情報は存在するが、ユーザーが登録していない場合、r010のみinsertする
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
          if user_article.save
            article.add_strength
            @msg = "登録が完了しました。" and return
          end
        end
      else

        image = getImagefromURL(@url);

        contents_preview = ""
        open(@url) do |io|
          html = io.read
          begin
            html = html.force_encoding("UTF-8")
            html = html.encode("UTF-8", "UTF-8")
            contents_preview, title = ExtractContent.analyse(html)
            # logger.debug("content_preview : #{contents_preview}")
          rescue => e
            # TODO : enable to handle "ArgumentError - invalid byte sequence in UTF-8:"
            logger.error("error :#{e}")
          end
        end
        #logger.debug("preview : #{contents_preview}}")

        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        #article = Article.new(:url => params[:url], :title => title, :contents_preview => contents_preview[0, 200], :category_id =>"001", :img => file);
        article = Article.new(:url => params[:url], :title => title, :contents_preview => contents_preview[0, 200], :category_id =>"001", :image => image.to_blob);
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
          if user_article.save
              article.add_strength
              @msg = "登録が完了しました。" and return
          end
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end
  
=begin
  def get_title
    if signed_in?
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        render :text => BLANK and return
      else
        render :text => title and return
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end
=end

  #指定されたurlのタイトルを返却するメソッド
  def returnTitle(url)
    begin
      charset = nil;
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        charset = f.charset;
        f.read;
      end
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8");
      if doc.title != nil && doc.title != BLANK
        return doc.title;
      else
      	#タイトルが取得出来ない時はホスト名をタイトルに設定する
        return URI.parse(url).host
      end
    rescue
      return nil;
    end
  end

  #指定されたURLで使用されている画像を抜き出すメソッド
  #パフォーマンス
  def getImagefromURL(url)
    begin
      no_image = Magick::ImageList.new("#{Rails.root}/app/assets/images/no_image.png").resize(WIDTH, HEIGHT)
      charset = nil;
      
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        charset = f.charset;
        f.read;
      end

      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8");
      doc.xpath("//img[starts-with(@src, 'http://')]").each{|img|
        #image_uri = URI.escape(img['src'])
        if open(URI.parse(img['src']))
          image = Magick::ImageList.new(img['src'])
        else
          next;
        end
        #画像の大きさから象徴的な画像を判断する
        #幅
        columns = image.columns 
        #高さ
        rows = image.rows
        #幅×高さが閾値を超える最初の画像を象徴的な画像として返却する
    		if columns.to_i > THRESHOLD_SIDE and rows.to_i > THRESHOLD_SIDE and (columns.to_i*rows.to_i) > THRESHOLD_ALL
          return image.resize(WIDTH, HEIGHT)
          break;
        end
      }

      #returnしていない場合（閾値を超える画像がなかった場合）
      return no_image

    rescue
      logger.error("getImgItem.rescue")
      return no_image
    end
  end
end
