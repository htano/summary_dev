# encoding: utf-8

require 'nokogiri'
require 'openssl'
require 'open-uri'
require 'kconv'

class WebpageController < ApplicationController

  def get_add_history_for_chrome_extension
    user_id = getLoginUser.id;
    @booked_url = "#{params[:booked_url]}";
    article = Article.find_by_url(@booked_url);
    if article != nil then
      user_article = article.user_articles.find_by_user_id_and_article_id(user_id, article.id);
      if user_article != nil then 
      #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、article.idを返却する
      render :text => article.id
      end
    end
  end

  def get_current_user_name_for_chrome_extension
    if signed_in?
      render :text => get_current_user_name;
    else
      render :text => "";
    end
  end

  def add_for_chrome_extension
      user_id = getLoginUser.id;
      @booked_url = "#{params[:booked_url]}";
      title = returnTitle(@booked_url);
      if title == nil
        return
      end
      article = Article.find_by_url(@booked_url);
      if article != nil then
        user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
        if user_article.save
          render :text => article.id
        end
      else
        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:booked_url],:title => title, :category_id =>"001");
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
          if user_article.save
            render :text => article.id
          end
        end
      end
  end

  def get_title
    if signed_in?
      @booked_url = "#{params[:booked_url]}";
      title = returnTitle(@booked_url);
      if title == nil
        render :text => "";
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
      @booked_url = "#{params[:booked_url]}";
      title = returnTitle(@booked_url);
      if title == nil
        render :text => "指定されたURLは存在しません。URLを確認して下さい。"
        return
      end
      article = Article.find_by_url(@booked_url);
      if article != nil then
        @article_id = article.id;
        user_article = article.user_articles.find_by_user_id_and_article_id(user_id, article.id);
          if user_article != nil then 
            #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、エラーメッセージを表示する
            render :text => "登録済みです。"
          else
            #同じURLの情報は存在するが、ユーザーが登録していない場合、r010のみinsertする
            user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
            if user_article.save
              render :text => "登録に完了しました。"
            end
          end
        else
        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:booked_url],:title => title, :category_id =>"001");
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
          if user_article.save
            render :text => "登録に完了しました。"
          end
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index";
 	end
  end

  #指定されたurlのタイトルを返却するメソッド
  def returnTitle(booked_url)
    begin
      charset = nil;
      html = open(booked_url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
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