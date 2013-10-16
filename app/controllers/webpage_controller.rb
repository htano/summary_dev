# encoding: utf-8

require "webpage"
include Webpage

class WebpageController < ApplicationController
  def add
    if signed_in?
      @user_id = params[:id]
      @msg = params[:msg]
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
        @msg = "Please check URL."
        redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
      end

      @title = h["title"]
      @recent_tags = UserArticle.get_recent_tag(@user_id)

      article = Article.find_by_url(@url) 
      unless article == nil
        user_article = article.user_articles.find_by_user_id(@user_id)
        unless user_article == nil
          @msg = "you already registered."
          redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
        end
        @summary_num = article.summaries.count(:all)
        @article_id = article.id
        @top_rated_tags = article.get_top_rated_tag
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
      article = Article.edit_article(@url)
      if article == nil
        @msg = "Please check URL."
        redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
      end
      user_article = UserArticle.edit_user_article(get_login_user.id, article.id)
      UserArticleTag.edit_user_article_tag(user_article.id, tag_list)
      article.add_strength
      @article_id = article.id
      @title = article.title
      @contents_preview = article.contents_preview
      @thumbnail = article.thumbnail
      @tags = []
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
      Article.find(@aid).remove_strength(get_login_user.id)
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
