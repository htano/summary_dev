require "open-uri"
require "rubygems"
require "nokogiri"
require "kconv"

class WebpageController < ApplicationController
  def add
    #TODO 堀田の作成したメソッドを呼ぶ
    @user_name = "#{params[:user_name]}";
    render "webpage/add"
  end
  
  def add_confirm
    #TODO 堀田の作成したメソッドを呼ぶ
    @user_name = "#{params[:user_name]}";
    @url = "#{params[:url]}";

    charset = nil;
    html = open(@url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
      charset = f.charset;
      f.read;
    end
    doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8");
    @title = doc.title;
  end

  def add_complete
    #TODO 堀田の作成したメソッドを呼ぶ
    @user_name = "#{params[:user_name]}";
    user_id = User.find_by_name(@user_name).id;
    #TODO first必要？
    #article = Article.where(:url => params[:url]).first;
    article = Article.find_by_url(params[:url]);
    if article != nil then
      #article_id = article.id;
      #@article_id = @article.id;
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
      #article_id = createArticleID();
      #@article_id = article_id;
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
end