# encoding: utf-8
require "webpage"
#require "awesome_print"
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
    redirect_to :action => "index" and return unless @articles
    render :template => "search/index" and return unless @articles

    case @sort
    when "1"
      @articles = @articles.order("created_at desc")
      @sort_menu_title = t("search.sort_newest")
    when "2"
      @articles = @articles.order("summaries_count desc, created_at desc")
      @sort_menu_title = t("search.sort_summary_num")
    when "3"
      @articles = @articles.order("user_articles_count desc, created_at desc")
      @sort_menu_title = t("search.sort_reader_num")
    else
      flash[:error] = "Please retry."
      redirect_to :action => "index" and return
    end

    @articles = @articles.page(params[:page]).per(PAGE_PER)
    #ap @articles

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
      @sort_menu_title = t("search.sort_follower_num")
    when "2"
      @users = @users.order("summaries_count desc, created_at desc")
      @sort_menu_title = t("search.sort_summary_num")
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
    remove_webpage(@atricle_id)
  end

  def follow
    @current_user = get_login_user

    if @current_user
      if User.exists?(params[:follow_user_id])
        FavoriteUser.create(:user_id => @current_user.id, :favorite_user_id => params[:follow_user_id])
      else
        respond_to do |format|
          format.html { render :file => "#{Rails.root}/public/404.html", 
                        :status => 404, :layout => false, :content_type => 'text/html'}
          format.js { render '404_error_page' and return }
        end
      end
    end

    @user_id = params[:follow_user_id]
    # for renewing followers number on profile view
    @num = FavoriteUser.count(:all, :conditions => {:favorite_user_id => params[:follow_user_id]})
    @follower_num = "followers" + "<br>" + @num.to_s

    respond_to do |format|
      format.html { redirect_to :action => "index", :name => User.find(@user_id).name }
      format.js
    end
  end

  def unfollow
    @current_user = get_login_user

    if @current_user && @current_user.favorite_users.exists?(:favorite_user_id => params[:unfollow_user_id])
      @current_user.favorite_users.find_by_favorite_user_id(params[:unfollow_user_id]).destroy
    else
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404.html", 
                      :status => 404, :layout => false, :content_type => 'text/html'}
        format.js { render '404_error_page' and return }
      end
    end

    @user_id = params[:unfollow_user_id]
    @follower_num = "followers" + "<br>" + 
                    FavoriteUser.count(:all, :conditions => {:favorite_user_id => params[:unfollow_user_id]}).to_s

    respond_to do |format|
      format.html { redirect_to :action => "index", :name => User.find(@user_id).name }
      format.js
    end
  end
end
