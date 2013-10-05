# encoding: utf-8

require "webpage"
include Webpage

class ChromeController < ApplicationController
  def get_add_history
    if signed_in?
      user_id = get_login_user.id
      @url = "#{params[:url]}"
      article = Article.find_by_url(@url)
      if article == nil
        render :text => BLANK and return
      else
        user_article = article.user_articles.find_by_user_id(user_id)
        if user_article == nil
          render :text => BLANK and return
        else
          render :text => article.id and return
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_current_user_name
    if signed_in?
      render :text => get_current_user_name and return
    else
      render :text => BLANK and return
    end
  end

  def get_recommand_tag
    @url = "#{params[:url]}"
    article = Article.find_by_url(@url)
    if article == nil
      render :text => nil and return
    else
      top_rated_tag = article.get_top_rated_tag
      render :text => top_rated_tag and return
    end
  end

  def get_recent_tag
    if signed_in?
      render :text => UserArticle.get_recent_tag(get_login_user.id) and return
    else
      render :text => BLANK and return
    end
  end


  #TODO 画面からURL直打ちの回避
  def add
    if signed_in?
      @prof_image = get_login_user.prof_image
      @url = "#{params[:url]}"
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
=begin
      UserArticleTag.edit_user_article_tag(user_article.id, tag_list)
=end
      article.add_strength
=begin
      @article_id = article.id
      @title = article.title
      @contents_preview = article.contents_preview
      @thumbnail = article.thumbnail
      @tags = []
      user_article.user_article_tags(:all).each do |user_article_tag|
        @tags.push(user_article_tag.tag)
      end
=end
      render :text => article.id and return
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_summary_num
    @url = "#{params[:url]}"
    article = Article.find_by_url(@url);
    if article == nil then
      render :text => 0 and return
    else
      render :text => article.summaries.size and return
    end
  end

  def get_summary_list
    @url = "#{params[:url]}"
    article = Article.find_by_url(@url);
    if article == nil then
      render :json => nil and return
    else
      summaries = article.summaries.find(:all,:limit => 10)
      if summaries == nil then
        render :json => nil and return
      else
        render :json => summaries and return
      end
    end
  end
end
