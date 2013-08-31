# encoding: utf-8

require 'nokogiri'
require 'openssl'
require 'open-uri'
require 'kconv'

class WebpageController < ApplicationController

  #定数定義
  BLANK = ""

  #TODO 画面からURL直打ちの回避
  def get_add_history_for_chrome_extension
    if signed_in?
      user_id = getLoginUser.id;
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html'
      end
      article = Article.find_by_url(@url);
      if article != nil then
        user_article = article.user_articles.find_by_user_id_and_article_id(user_id, article.id);
        if user_article != nil then 
          #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、article.idを返却する
          render :text => article.id
        else
          render :text => BLANK
        end
      else
        render :text => BLANK
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_current_user_name_for_chrome_extension
    if signed_in?
      render :text => get_current_user_name;
    else
      render :text => BLANK
    end
  end

  #TODO 画面からURL直打ちの回避
  def add_for_chrome_extension
    if signed_in?
      user_id = getLoginUser.id;
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html'
        return
      end
      article = Article.find_by_url(@url);
      if article != nil then
        user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
        if user_article.save
          render :text => article.id
        end
      else
        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:url],:title => title, :category_id =>"001");
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
          if user_article.save
            render :text => article.id
          end
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  def get_title
    if signed_in?
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        render :text => BLANK
        return
      else
        render :text => title;
        return
      end
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  def add
  	if signed_in?
      user_id = getLoginUser.id;
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      if title == nil
        render :text => "指定されたURLは存在しません。URLを確認して下さい。"
        return
      end
      article = Article.find_by_url(@url);
      if article != nil then
        user_article = article.user_articles.find_by_user_id_and_article_id(user_id, article.id);
          if user_article != nil then 
            #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、エラーメッセージを表示する
            render :text => "登録済みです。"
          else
            #同じURLの情報は存在するが、ユーザーが登録していない場合、r010のみinsertする
            user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
            if user_article.save
              render :text => "登録が完了しました。"
            end
          end
        else
        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:url],:title => title, :category_id =>"001");
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
          if user_article.save
            render :text => "登録が完了しました。"
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
      charset = nil;
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        charset = f.charset;
        f.read;
      end
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8");
      return doc.title;
    rescue
      return nil;
    end
  end
end