# encoding: utf-8
require "webpage"
include Webpage

class SearchController < ApplicationController

  PAGE_PER = 25
  BLANK = ""

  #初期表示
  def index
    @target = 1
    @type = 1
    @sort = 1
    @category = 0
  end

  def search_article
    @searchtext = params[:searchtext]
    @target = params[:target] == BLANK || params[:target] == nil ? "1" : params[:target]
    @type = params[:type] == BLANK || params[:type] == nil ? "1" : params[:type]
    @sort = params[:sort] == BLANK || params[:sort] == nil ? "1" : params[:sort]
    @category = params[:category] == BLANK || params[:category] == nil ? "0" : params[:category]
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
      flash[:error] = "Please retry."
      redirect_to :action => "index" and return
    end
    unless @category == "0" or @articles == nil
      @articles = @articles.where("category_id" => @category)
    end
    if @articles == nil
      @article_num = 0
    else
      @article_num = @articles.length
    end
    p"!!!"
    p @category
    p"!!!"
    redirect_to :action => "index" and return unless @articles
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
    @sort = params[:sort] == BLANK || params[:sort] == nil ? "1" : params[:sort]
    @users = User.where(["name LIKE ? or full_name LIKE ?", "%"+@searchtext+"%", "%"+@searchtext+"%"]).where("yuko_flg" => true)
    @user_num = @users == BLANK || @users == nil ? 0 : @users.length

    case @sort
    when "1"
      @users = @users.sort_by! {|user| user.get_followers_count }.reverse
      @sort_menu_title = "Follower num"
    when "2"
      @users = @users.order("summaries_count desc, created_at desc")
      @sort_menu_title = "Summary num"
    else
      flash[:error] = "Please retry."
      redirect_to :action => "index" and return
    end

    @users = Kaminari.paginate_array(@users).page(params[:page]).per(PAGE_PER)

    render :template => "search/index"
  end

  def read
    @atricle_id = params[:article_id]
    article = Article.find(@atricle_id)
    add_webpage(article.url)
  end

  def not_read
    @atricle_id = params[:article_id]
    article = Article.find(@atricle_id)
    article.user_articles.find_by_user_id(get_login_user.id).destroy()
  end
end
