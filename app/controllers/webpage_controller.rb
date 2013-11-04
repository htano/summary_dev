require "webpage"
include Webpage

class WebpageController < ApplicationController
  def add
    if signed_in?
      @user_id = params[:id]
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def add_confirm
    if signed_in?
      @user_id = get_login_user.id
      @url = params[:url]
      h =   get_webpage_element(@url, true, false, false)
      if h == nil || @url.start_with?("chrome://extensions/")
        flash[:error] = "Please check URL."
        redirect_to :controller => "webpage", :action => "add" and return
      end

      @title = h["title"]
      @recent_tags = UserArticle.get_recent_tag(@user_id)
      @set_tags = []

      article = Article.find_by_url(@url)
      unless article == nil
        user_article = article.user_articles.find_by_user_id(@user_id)
        @summary_num = article.summaries_count
        @reader_num = article.user_articles_count
        @article_id = article.id
        @top_rated_tags = article.get_top_rated_tag
        @set_tags = user_article.get_set_tag
      end

    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def add_complete
    if signed_in?
      @prof_image =  get_login_user.prof_image
      @url = params[:url]
      tag_list = []
      params.each do |key,value|
        if key.start_with?("tag_text_")
          tag_list.push(value) unless value == BLANK || tag_list.include?(value)
        end
      end
      article = add_webpage(@url, tag_list)
      if article == nil
        flash[:error] = "Please check URL."
        redirect_to :controller => "webpage", :action => "add" and return
      end
      @article_id = article.id
      @title = article.title
      @contents_preview = article.contents_preview
      @thumbnail = article.thumbnail
      @tags = []
      user_article = article.user_articles.find_by_user_id(get_login_user.id)
      user_article.user_article_tags(:all).each do |user_article_tag|
        @tags.push(user_article_tag.tag)
      end
      @msg = "Completed." and return
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def delete
    @aid = params[:article_id]
    user_article = get_login_user.user_articles.find_by_article_id(@aid)
    if user_article
      article = Article.find(@aid)
      article.remove_strength(get_login_user.id)
      get_login_user.delete_cluster_id(article.cluster_id)
      user_article.destroy
      render :text => "OK"
    else
      render :text => "NG"
    end
  end

  def mark_as_read
    @msg = "NG"
    @aid = params[:article_id]
    @user_article = get_login_user.user_articles.find_by_article_id(@aid)
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
end
