# encoding: utf-8

require 'nokogiri'
require 'openssl'
require 'open-uri'
require 'kconv'

class WebpageController < ApplicationController
  
  def add_confirm
    @url = "#{params[:url]}";
    @title = returnTitle(@url);
  end

  def add_complete
    if signed_in?
      user_id = getLoginUser.id;
      @url = "#{params[:url]}";
      title = returnTitle(@url);
      article = Article.find_by_url(@url);
      if article != nil then
        @article_id = article.id;
        user_article = UserArticle.find_by_user_id_and_article_id(user_id, article.id);
          if user_article != nil then 
            #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、エラーメッセージを表示する
            #TOTO
            @msg = "あなたはすでに登録しています！"
          else
            #同じURLの情報は存在するが、ユーザーが登録していない場合、r010のみinsertする
            user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false);
            if user_article.save
            @msg = "登録に完了しました！"
            end
          end
     else
        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:url],:title => title, :category_id =>"001");
        if article.save
          @article_id = article.id;
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false);
          if user_article.save
            @msg = "登録に完了しました！"
          end
        end
     end
   else
    redirect_to :controller=>"consumer",:action=>"index", :fromUrl => request.url;
   end
  end

  #指定されたurlのタイトルを返却するメソッド
  def returnTitle(url)
    charset = nil;
    html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
      charset = f.charset;
      f.read;
    end
    doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8");
    return doc.title;
  end

end