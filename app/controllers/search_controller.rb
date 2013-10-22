# encoding: utf-8

class SearchController < ApplicationController

  PAGE_PER = 25

  #初期表示
  def index
    @target = 1
    @sort = 1
  end

  def search
    @searchtext = params[:searchtext]
    @target = params[:target] == "" || params[:target] == nil ? "1" : params[:target]
    @sort = params[:sort] == "" || params[:sort] == nil ? "1" : params[:sort]
    @articles = []
    @articles_num = 0
    case @target
    when "1"
      @articles = Article.search_by_content(@searchtext)
      @target_text = "タイトル＆本文"
    when "2"
      @articles = Article.search_by_tag(@searchtext)
      @target_text = "タグ"
    when "3"
      @articles = Article.search_by_domain(@searchtext)
      @target_text = "ドメイン"
    else
      flash[:error] = "Please check search targets."
      redirect_to :action => "index" and return
    end
    @articles_num = @articles.length
    redirect_to :action => "index", :target => @target, :sort => @sort and return unless @articles
    render :template => "search/index" and return unless @articles

    case @sort
    when "1"
      @articles = @articles.order("created_at desc")
      @sort_menu_title = "Newest"
    when "2"
      @articles = @articles.order("summaries_count desc, created_at desc")
      @sort_menu_title = "Summary num"
    when "3"
      @articles = @articles.order("user_articles_count desc, created_at desc")
      @sort_menu_title = "Reader num"
    else
      flash[:error] = "Please retry."
      redirect_to :action => "index" and return
    end

    @articles = @articles.page(params[:page]).per(PAGE_PER)

    render :template => "search/index"
  end
end
