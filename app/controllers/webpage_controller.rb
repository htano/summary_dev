# encoding: utf-8

require "nokogiri"
require 'openssl'

class WebpageController < ApplicationController
  
  def add_confirm
    @url = "#{params[:url]}";
    @title = returnTitle(@url);
  end

  def add_complete
    user_id = getLoginUser.id;
    article = Article.find_by_url(params[:url]);
    if article != nil then
      @article_id = article.id;
      user_article = UserArticle.find_by_user_id_and_article_id(user_id, article.id);
        if user_article != nil then 
          #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、エラーメッセージを表示する
          @msg = "あなたはすでに"+params[:title]+"を登録しています！"
        else
          #同じURLの情報は存在するが、ユーザーが登録していない場合、r010のみinsertする
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
          if user_article.save
           @msg = params[:title] + "の登録に完了しました！"
          end
        end
   else
      #同じURLの情報がない場合、a010とr010両方にinsertする
      #カテゴリはペンディング事項
      article = Article.new(:url => params[:url],:title => params[:title], :category_id =>"001");
      if article.save
        @article_id = article.id;
        user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
        if user_article.save
          @msg = params[:title] + "の登録に完了しました！"
        end
      end
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
      @msg ="指定されたURLは存在しません";
      render "webpage/invalid"
    end
  end
end