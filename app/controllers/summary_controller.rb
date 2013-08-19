# encoding: utf-8

class SummaryController < ApplicationController
  def edit
    if signed_in?
      article = Article.find_by id: params[:articleId]
      if article == nil then
        redirect_to :controller => "mypage", :action => "index" 
        return
      end
      #article = existArticle?(params[:article_id]);
      @url = article.url;
      @title = article.title;
      user_id = getLoginUser.id;
      summary = Summary.find_by_user_id_and_article_id(user_id, params[:article_id]);
      if summary != nil then
        @content = summary.content;
      end
    else
      redirect_to :controller => "consumer", :action => "index";
      #redirect_to :controller => "consumer", :action => "index", :fromUrl => request.url;
    end
  end

  def edit_confirm
    if signed_in?
      article = Article.find_by id: params[:articleId]
      if article == nil then
        redirect_to :controller => "mypage", :action => "index" 
        return
      end
      #article = existArticle?(params[:article_id]);
      @url = article.url;
      @title = article.title;
      user_id = getLoginUser.id;
      @summary_content = "#{params[:summary_content]}";
    else
      redirect_to :controller => "consumer", :action => "index";
      #redirect_to :controller => "consumer", :action => "index", :fromUrl => request.url;
    end      
  end

  def edit_complete
    if signed_in?
      user_id = getLoginUser.id;
      article = Article.find_by id: params[:articleId]
      if article == nil then
        redirect_to :controller => "mypage", :action => "index" 
        return
      end
      #article = existArticle?(params[:article_id]);
      summary = Summary.find_by_user_id_and_article_id(user_id, params[:article_id]);
      if summary != nil then
        #すでに当該記事に対して要約が登録されていた場合、以下の処理をする
        summary.update_attribute(:content, params[:summary_content]);
        if summary.save
          redirect_to :action => "show";
        end
      else
        #当該記事に対して要約が登録されていなかった場合、以下の処理をする
        summary = Summary.new(:content => params[:summary_content],:user_id => user_id,:article_id => params[:article_id]);
        if summary.save
          redirect_to :action => "show";
        end
      end 
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  def show
    if signed_in?
      article = Article.find_by id: params[:articleId]
      if article == nil then
        redirect_to :controller => "mypage", :action => "index" 
        return
      end
      #article = existArticle?(params[:article_id]);
      @url = article.url;
      @title = article.title;
      user_id = getLoginUser.id;
      @article_id = "#{params[:article_id]}";
      summary = Summary.find_by_user_id_and_article_id(user_id, @article_id);
      @summary_content = summary.content;
      @msg = "要約が登録出来ました！"
    else
      redirect_to :controller => "consumer", :action => "index";
    end
  end

  def existArticle?(article_id)
    @article = Article.returnArticle(article_id);
    if @article == nil then
    logger.error("!")
    redirect_to :controller => "mypage", :action => "index";
      #render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html'
      return
    else
    logger.error("!!")
      return @article
    end
  end
end
  