include FollowManager
include Webpage

class MypageController < ApplicationController
  RENDER_USERS_NUM = 13
  RENDER_FAVORITE_USERS_NUM = RENDER_USERS_NUM
  RENDER_FOLLOWERS_NUM = RENDER_USERS_NUM
  TABLE_ROW_NUM = 20

  before_filter :require_login_with_name, :only => [:index]
  before_filter :require_login, :except => [:index]

  def index
    @table_row_num = TABLE_ROW_NUM
    get_profile_info()

    update_sort_type(cookies, params[:direction], params[:sort])
    sort_info = get_sort_info(cookies)
    @sort_menu_title = sort_info[:menu_title]
    order_condition = sort_info[:condition]

    @mpage = get_page(params[:mpage])
    offset = (@mpage.to_i - 1) * TABLE_ROW_NUM
    unread_articles = get_unread_articles(@user, order_condition, offset, TABLE_ROW_NUM)
    unless unread_articles.size > 0
      unread_articles = get_unread_articles(@user, order_condition, 0, TABLE_ROW_NUM)
      @mpage = 1
    end
    @main_articles_table = get_table_data(@user, unread_articles, @is_login_user)
    @total_main_articles_num = @user.user_articles.unread.size

    @fpage = get_page(params[:fpage])
    offset = (@fpage.to_i - 1) * TABLE_ROW_NUM
    favorite_articles = get_favorite_articles(@user, order_condition, offset, TABLE_ROW_NUM)
    unless favorite_articles.size > 0
      favorite_articles = get_favorite_articles(@user, order_condition, 0, TABLE_ROW_NUM)
      @fpage = 1
    end
    @favorite_articles_table = get_table_data(@user, favorite_articles, @is_login_user)
    @total_favorite_articles_num = @user.user_articles.favorite.size

    @rpage = get_page(params[:rpage])
    offset = (@rpage.to_i - 1) * TABLE_ROW_NUM
    read_articles = get_read_articles(@user, order_condition, offset, TABLE_ROW_NUM)
    unless read_articles.size > 0
      read_articles = get_read_articles(@user, order_condition, 0, TABLE_ROW_NUM)
      @rpage = 1
    end
    @read_articles_table = get_table_data(@user, read_articles, @is_login_user)
    @total_read_articles_num = @user.user_articles.read.size

    @spage = get_page(params[:spage])
    offset = (@spage.to_i - 1) * TABLE_ROW_NUM
    summarized_articles = get_summarized_articles(@user, order_condition, offset, TABLE_ROW_NUM)
    unless summarized_articles.size > 0
      summarized_articles = get_summarized_articles(@user, order_condition, 0, TABLE_ROW_NUM)
      @spage = 1
    end
    @summaries_table = get_table_data(@user, summarized_articles, @is_login_user, true)

    if params[:mpage]
      @current_tab = "main"
    elsif params[:spage]
      @current_tab = "summary"
    elsif params[:fpage]
      @current_tab = "favorite"
    elsif params[:rpage]
      @current_tab = "read"
    else
      @current_tab = "main"
    end

    respond_to do |format|
      format.html { render :layout => 'application'}
      format.js
    end

  end

  def tag
    get_profile_info()
  end

  def delete_article
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      article = login_user.user_articles.find_by_article_id(article_id)
      unless article == nil
        Article.find(article_id).remove_strength(get_login_user.id)
        login_user.delete_cluster_id(
          Article.find(article_id).cluster_id
        )
        article.destroy
      end
    end
    redirect_to :action => "index", :params => params
  end

  def delete_summary
    login_user = get_login_user
    params[:article_ids].each do |article_id|
      summary = login_user.summaries.find_by_article_id(article_id)
      unless summary == nil
        summary.destroy
      end
    end

    redirect_to :action => "index", :params => params
  end

  def mark_as_read
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.read_flg != true
        article.read_flg = true
        article.save
      end
    end

    redirect_to :action => "index", :params => params
  end

  def mark_as_unread
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.read_flg == true
        article.read_flg = false
        article.save
      end
    end

    redirect_to :action => "index", :params => params
  end

  def mark_as_favorite
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.favorite_flg != true
        article.favorite_flg = true
        article.save
      end
    end

    redirect_to :action => "index", :params => params
  end

  def mark_off_favorite
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.favorite_flg == true
        article.favorite_flg = false
        article.save
      end
    end

    redirect_to :action => "index", :params => params
  end

  def clip
    params[:article_ids].each do |article_id|
      if Article.exists?(article_id)
        url = Article.find_by_id(article_id).url
        add_webpage(url) if url
      end
    end

    redirect_to :action => "index", :params => params
  end

  def follow
    @current_user = get_login_user

    if @current_user
      if User.exists?(params[:follow_user_id])
        FavoriteUser.create(:user_id => @current_user.id, :favorite_user_id => params[:follow_user_id])
      else
        respond_to do |format|
          format.html { render :file => "#{Rails.root}/public/404.html", 
                        :status => 404, :layout => false, :content_type => 'text/html' and return }
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
                      :status => 404, :layout => false, :content_type => 'text/html' and return }
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

  def destroy
    @user = User.find_by_name(params[:name]).destroy
    render :nothing => true
  end

private
  def require_login_with_name
    if params[:name]
      unless User.exists?(:name => params[:name])
        render :file => "#{Rails.root}/public/404.html", 
               :status => 404, :layout => false, :content_type => 'text/html'
      end
    else
      unless signed_in?
        redirect_to :controller => 'consumer', :action => 'index'
      end
    end
  end

  def require_login
    unless signed_in?
      respond_to do |format|
        format.html { redirect_to :controller => 'consumer', :action => 'index' and return }
        format.js { render 'login_page' and return }
      end
    end
  end

  def get_profile_info
    @is_login_user = params[:name] ? login_user?(params[:name]) : true

    if @is_login_user
      @user = get_login_user
      @user.update_mypage_access
    else
      @user = User.find_by_name(params[:name])
      @is_already_following = is_already_following?(@user.id)
    end

    favorite_users = get_favorite_users(@user)
    @favorite_users_info = {:num => favorite_users.length ,
                            :lists => favorite_users[0..RENDER_FAVORITE_USERS_NUM]}

    followers = get_followers(@user)
    @followers_info = {:num => followers.length,
                        :lists => followers[0..RENDER_FOLLOWERS_NUM]}

    @total_summaries_num = @user.summaries.size
  end

  def is_already_following?(user_id)
    is_already_following = false;
    if signed_in?
      if get_login_user.favorite_users.exists?(:favorite_user_id => user_id)
        is_already_following = true
      end
    end
    is_already_following
  end

  def update_sort_type(cookies, direction, sort)
    if direction
      cookies[:direction] = {:value => direction, :expires => 7.days.from_now }
    end
    if sort
      cookies[:sort] = {:value => sort, :expires => 7.days.from_now }
    end
  end

  def get_sort_info(cookies)
    case cookies[:sort]
    when "registered"
      if cookies[:direction] == "asc"
        {:menu_title => "Oldest", :condition => "created_at ASC"}
      else
        {:menu_title => "Newest", :condition => "created_at DESC"}
      end
    when "summaries"
      if cookies[:direction] == "asc"
        {:menu_title => "Least summarized", :condition => "summaries_count ASC"}
      else
        {:menu_title => "Most summarized", :condition => "summaries_count DESC"}
      end
    when "reader"
      if cookies[:direction] == "asc"
        {:menu_title => "Least read", :condition => "user_articles_count ASC"}
      else
        {:menu_title => "Most read", :condition => "user_articles_count DESC"}
      end
    else
      {:menu_title => "Newest", :condition => "created_at DESC"}
    end
  end

  def get_page(param_page)
    page = param_page ? param_page : 1
    page = page.to_i > 1 ? page : 1
    page
  end

  def get_unread_articles(user, order_condition = nil, offset = 0, num = -1)
    articles = []
    if order_condition && order_condition.index("created_at")
      ordered_user_articles = 
        user.user_articles.order(order_condition).offset(offset).unread.limit(num)
      ordered_user_articles.each do |user_article|
        article = user_article.article
        articles.push(article)
      end
    else
      article_ids = user.user_articles.unread.select(:article_id)
      articles = Article.where(:id => article_ids).order(order_condition).offset(offset).limit(num)
    end
    articles
  end

  def get_read_articles(user, order_condition = nil, offset = 0, num = -1)
    articles = []
    if order_condition && order_condition.index("created_at")
      ordered_user_articles = 
        user.user_articles.order(order_condition).offset(offset).read.limit(num)
      ordered_user_articles.each do |user_article|
        article = user_article.article
        articles.push(article)
      end
    else
      article_ids = user.user_articles.read.select(:article_id)
      articles = Article.where(:id => article_ids).order(order_condition).offset(offset).limit(num)
    end
    articles
  end

  def get_favorite_articles(user, order_condition = nil, offset = 0, num = -1)
    articles = []
    if order_condition && order_condition.index("created_at")
      ordered_user_articles = 
        user.user_articles.order(order_condition).offset(offset).favorite.limit(num)
      ordered_user_articles.each do |user_article|
        article = user_article.article
        articles.push(article)
      end
    else
      article_ids = user.user_articles.favorite.select(:article_id)
      articles = Article.where(:id => article_ids).order(order_condition).offset(offset).limit(num)
    end
    articles
  end

  def get_summarized_articles(user, order_condition = nil, offset = 0, num = -1)
    articles = []
    if order_condition && order_condition.index("created_at")
      ordered_summarized_articles = 
        user.summaries.order(order_condition).offset(offset).limit(num)
      ordered_summarized_articles.each do |summarized_article|
        article = Article.find(summarized_article.article_id)
        articles.push(article)
      end
    else
      article_ids = user.summaries.select(:article_id)
      articles = Article.where(:id => article_ids).order(order_condition).offset(offset).limit(num)
    end
    articles
  end

  def get_table_data(user, articles, is_login_user, is_summary = false)
    table_data = []
    articles.each do |article|
      summary_num = 
        article.summaries_count ? article.summaries_count : 0
      registered_num = 
        article.user_articles_count ? article.user_articles_count : 0

      registered_date = Time.now
      if user.user_articles.exists?(:article_id => article.id)
        registered_date = user.user_articles.find_by_article_id(article.id).created_at
      end

      last_updated =
        is_summary ? user.summaries.find_by_article_id(article.id).updated_at : nil
      like_num = 
        is_summary ? user.summaries.find_by_article_id(article.id).good_summaries.size : nil

      user_article_ids = user.user_articles.where(:article_id => article.id).select(:id)
      tags = UserArticleTag.where(:user_article_id => user_article_ids).pluck(:tag)

      is_registered = false
      is_already_read = false

      if signed_in? && is_login_user == false
        if get_login_user.user_articles.exists?(:article_id => article.id)
          is_registered = true
          is_already_read = 
            get_login_user.user_articles.find_by_article_id(article.id).read_flg
        end
      end

      data = {:article => article, 
              :summary_num => summary_num,
              :registered_num => registered_num,
              :registered_date => registered_date, 
              :is_registered => is_registered, 
              :is_already_read => is_already_read,
              :like_num => like_num,
              :last_updated => last_updated,
              :tags => tags}

      table_data.push(data)
    end

    table_data
  end
end
