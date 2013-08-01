require "open-uri"
require "rubygems"
require "nokogiri"
require "kconv"

class WebpageController < ApplicationController
  def add
    #render :text => "adding webpage by #{params[:id]}"
    @user_name = "#{params[:user_name]}";
    render "webpage/add"
  end
  
  def add_confirm
    @user_name = "#{params[:user_name]}";
    @url = "#{params[:url]}";

    charset = nil;
    html = open(@url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
      charset = f.charset;
      f.read;
    end
    doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8");
    @title = doc.title;
    #render :text => @title;
  end

  def add_complete
    @user_name = "#{params[:user_name]}";
    @user_id = findUserIdByUserName(@user_name);
    article = A010Article.where(:article_url => params[:url]).first;
    if article
      article_id = article.article_id;
      @article_id = article_id;
      user_article = R010UserArticle.where(:user_id => @user_id, :article_id => article_id).first;
        if user_article
          #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、エラーメッセージを表示する
          @msg = "あなたはすでに"+params[:title]+"を登録しています！"
        else
          #同じURLの情報は存在するが、ユーザーが登録していない場合、r010のみinsertする
          @user_article = R010UserArticle.new(:user_id => @user_id, :article_id => article_id,:read_flg => false);
          if @user_article.save
           @msg = params[:title] + "の登録に完了しました！"
          end
        end
    else
      #同じURLの情報がない場合、a010とr010両方にinsertする
      article_id = createArticleID();
      @article_id = article_id;
      #カテゴリはペンディング事項
      @article = A010Article.new(:article_id => article_id, :article_url => params[:url],:article_title => params[:title], :category_id =>"001");
      @user_article = R010UserArticle.new(:user_id => @user_id, :article_id => article_id,:read_flg => false);
      if @article.save && @user_article.save
        @msg = params[:title] + "の登録に完了しました！"
      end
    end
  end

  #記事IDの導出
  #すでに登録されているIDをインクリメントして導出する。1件も記事が登録されていない場合は1を返す。
  def createArticleID
      article = A010Article.first(:order => "created_at DESC");
      if article
        article_id = article.article_id;
        return article_id += 1;
      else
        return article_id = 1;
      end
  end

  def findUserIdByUserName(user_name)
    user = U010User.where(:user_name => params[:user_name]).first;
    return user.user_id;
  end


end
