# encoding: utf-8

class SearchController < ApplicationController

  PAGE_PER = 25
  BLANK = ""

  #初期表示
  def index
    @target = 1
    @type = 1
    @sort = 1
  end

  def search_article
    @searchtext = params[:searchtext]
    @target = params[:target] == BLANK || params[:target] == nil ? "1" : params[:target]
    p @target
    @type = params[:type] == BLANK || params[:type] == nil ? "1" : params[:type]
    @sort = params[:sort] == BLANK || params[:sort] == nil ? "1" : params[:sort]
    @articles = []
    @article_num = 0
    case @type
    when "1"
      @articles = Article.search_by_content(@searchtext)
      @type_text = "タイトル＆本文"
    when "2"
      @articles = Article.search_by_tag(@searchtext)
      @type_text = "タグ"
    when "3"
      @articles = Article.search_by_domain(@searchtext)
      @type_text = "ドメイン"
    else
      flash[:error] = "Please check search types."
      redirect_to :action => "index" and return
    end
    @article_num = @articles.length
    redirect_to :action => "index", :type => @type, :sort => @sort and return unless @articles
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

  def search_user
    @searchtext = params[:searchtext]
    @target = params[:target] == BLANK || params[:target] == nil ? "1" : params[:target]
    @type = params[:type] == BLANK || params[:type] == nil ? "1" : params[:type]
    @sort = params[:sort] == BLANK || params[:sort] == nil ? "1" : params[:sort]
    @users = User.where(["name LIKE ? or full_name LIKE ?", "%"+@searchtext+"%", "%"+@searchtext+"%"])
    @users.find_by_public_flg_and_yuko_flg(true,true)
    @user_num = @users == BLANK || @users == nil ? 0 : @users.length
    @users = @users.page(params[:page]).per(PAGE_PER)

    render :template => "search/index"
  end
end
