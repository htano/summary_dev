# encoding: utf-8

require "json"
require "webpage"
include Webpage

class ChromeController < ApplicationController
  def edit_tag
    if signed_in?
      url = params[:url]
      tag_list = []
      params.each do |key,value|
        if key.start_with?("tag_text_")
          tag_list.push(value) unless value == BLANK || tag_list.include?(value)
        end
      end
      article = Article.find_by_url(url)
      UserArticleTag.edit_user_article_tag(article.user_articles.find_by_user_id(get_login_user.id).id, tag_list)
      article.add_strength
      result = {"article_id" => article.id, "msg" => "タグ編集が完了しました。"}
      render :json => result and return
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def get_article_data
    if signed_in?
      url = params[:url]
      unless url.start_with?("http")
        result = {"article_id" => BLANK, "msg" => "この記事は登録出来ません。"}
        render :json => result and return
      end
      article = Article.find_by_url(url)
      if article == nil
        result = {"article_id" => BLANK, "msg" => BLANK}
        render :json => result and return
      else
        user_article = article.user_articles.find_by_user_id(get_login_user.id)
        if user_article == nil
          result = {"article_id" => BLANK, "msg" => BLANK}
          render :json => result and return
        else
          result = {"article_id" => article.id, "msg" => "登録済みです。"}
          render :json => result and return
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_login_user_id
    if signed_in?
      render :text => get_login_user.id and return
    else
      render :text => BLANK and return
    end
  end

  def get_set_tag
    url = params[:url]
    article = Article.find_by_url(url)
    if article == nil
      render :text => BLANK and return
    else
      user_article = article.user_articles.find_by_user_id(get_login_user.id)
      set_tags = user_article.get_set_tag
      if set_tags.length == 0
        render :text => BLANK and return
      else
        render :text => set_tags and return
      end
    end
  end

  def get_recommend_tag
    url = params[:url]
    article = Article.find_by_url(url)
    if article == nil
      render :text => BLANK and return
    else
      top_rated_tag = article.get_top_rated_tag
      if top_rated_tag.length == 0
        render :text => BLANK and return
      else
        render :text => top_rated_tag and return
      end
    end
  end

  def get_recent_tag
    if signed_in?
      recent_tag = UserArticle.get_recent_tag(get_login_user.id)
      if recent_tag.length == 0
        render :text => BLANK and return
      else
        render :text => recent_tag and return
      end
    else
      render :text => BLANK and return
    end
  end


  #TODO 画面からURL直打ちの回避
  def add
    if signed_in?
      url = params[:url]
      tag_list = []
      params.each do |key,value|
        if key.start_with?("tag_text_")
          tag_list.push(value) unless value == BLANK || tag_list.include?(value)
        end
      end
      article = Article.edit_article(url)
      if article == nil
        result = {"article_id" => BLANK, "msg" => "この記事は登録出来ません。"}
        render :json => result and return
      end

      user_article = UserArticle.edit_user_article(get_login_user.id, article.id)
      UserArticleTag.edit_user_article_tag(user_article.id, tag_list)
      article.add_strength
      result = {"article_id" => article.id, "msg" => "登録出来ました。"}
      render :json => result and return
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_background_info
    url = params[:url]
    result = []
    article = Article.find_by_url(url);
    if article == nil then
      result = {"summary_num" => 0, "user_article_id" => BLANK}
    else
      user_article = article.user_articles.find_by_user_id(get_login_user.id)
      if user_article == nil then
        result = {"summary_num" => article.summaries.size, "user_article_id" => BLANK}
      else
        result = {"summary_num" => article.summaries.size, "user_article_id" => user_article.id}
      end
    end
    p result
    render :json => result and return
  end

  def get_summary_list
    url = params[:url]
    article = Article.find_by_url(url);
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
