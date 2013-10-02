# encoding: utf-8

#TODO flashのスタイル等々微妙なので調整が必要
class SearchController < ApplicationController
  #初期表示
  def index
    @condition = 1
    @sort = 1
    @focus = 1
  end

  def search
    @searchtext = "#{params[:searchtext]}"
    @condition = "#{params[:condition]}"
    @sort = "#{params[:sort]}"
    @focus = "#{params[:focus]}"
    p @condition
    p @sort
    p @focus
    @articles = []
    case @condition
    when "1"
      @articles = Article.search_by_tag(@searchtext)
    when "2"
      @articles = Article.search_by_title(@searchtext)
    when "3"
      @articles = Article.search_by_content(@searchtext)
    else
      flash[:error] = "Please check search conditions."
      redirect_to :action => "index" and return
    end

    redirect_to :action => "index" and return unless @articles

    case @focus
    when "1"
      @articles = @articles
    when "2"
      @articles = @articles.where("user_articles.user_id", get_login_user.id)
    when "3"
      @articles = @articles.where.not("user_articles.user_id", get_login_user.id)
    else      
      flash[:error] = "Please check search conditions."
      redirect_to :action => "index" and return
    end

    case @sort
    when "1"
      @articles = @articles.order("created_at desc")
    when "2"
      @articles = @articles.order("summaries_count desc, created_at desc")
    else
      flash[:error] = "Please check search conditions."
      redirect_to :action => "index" and return
    end

    render :template => "search/index"
  end
end
