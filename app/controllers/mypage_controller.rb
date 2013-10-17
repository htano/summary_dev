include FollowManager

class MypageController < ApplicationController
  RENDER_USERS_NUM = 13
  RENDER_FAVORITE_USERS_NUM = RENDER_USERS_NUM
  RENDER_FOLLOWERS_NUM = RENDER_USERS_NUM
  TABLE_ROW_NUM = 20

  before_filter :require_login_with_name, :only => [:index]
  before_filter :require_login, :except => [:index]

  def index
    @table_row_num = TABLE_ROW_NUM
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










    renew_sort_type(cookies, params[:direction], params[:sort])
    sort_info = get_sort_info(cookies)
    @sort_menu_title = sort_info[:menu_title]
    sort_order_condition = sort_info[:condition]
    # logger.debug("title : #{sort_info[:menu_title]}, condition : #{sort_info[:condition]}")

    # main tab & favorite tab & read tab
    @main_articles_table = []
    @mpage = params[:mpage] ? params[:mpage] : 1
    @mpage = @mpage.to_i > 1 ? @mpage : 1
    offset = (@mpage.to_i - 1) * TABLE_ROW_NUM
    user_articles = 
      @user.user_articles.order(sort_order_condition).offset(offset).unread.take(TABLE_ROW_NUM)
    if user_articles.size == 0
      user_articles = 
        @user.user_articles.order(sort_order_condition).offset(0).unread.take(TABLE_ROW_NUM)
      @mpage = 1
    end
    @main_articles_table = get_table(user_articles, @is_login_user)
    @total_main_articles_num = @user.user_articles.unread.size

    @favorite_articles_table = []
    @fpage = params[:fpage] ? params[:fpage] : 1
    @fpage = @fpage.to_i > 1 ? @fpage : 1
    offset = (@fpage.to_i - 1) * TABLE_ROW_NUM
    user_articles = 
      @user.user_articles.order(sort_order_condition).offset(offset).favorite.take(TABLE_ROW_NUM)
    if user_articles.size == 0
      user_articles = 
        @user.user_articles.order(sort_order_condition).offset(0).favorite.take(TABLE_ROW_NUM)
      @fpage = 1
    end
    @favorite_articles_table = get_table(user_articles, @is_login_user)
    @total_favorite_articles_num = @user.user_articles.favorite.size

    @read_articles_table = []
    @rpage = params[:rpage] ? params[:rpage] : 1
    @rpage = @rpage.to_i > 1 ? @rpage : 1
    offset = (@rpage.to_i - 1) * TABLE_ROW_NUM
    user_articles = 
      @user.user_articles.order(sort_order_condition).offset(offset).read.take(TABLE_ROW_NUM)
    if user_articles.size == 0
      user_articles = 
        @user.user_articles.order(sort_order_condition).offset(0).read.take(TABLE_ROW_NUM)
      @rpage = 1
    end
    @read_articles_table = get_table(user_articles, @is_login_user)
    @total_read_articles_num = @user.user_articles.read.size
    
    # summary tab
    @summaries_table = []
    @spage = params[:spage] ? params[:spage] : 1
    @spage = @spage.to_i > 1 ? @spage : 1
    offset = (@spage.to_i - 1) * TABLE_ROW_NUM
    summaries = 
      @user.summaries.order(sort_order_condition).offset(offset).take(TABLE_ROW_NUM)
    if summaries.size == 0
      summaries = 
        @user.summaries.order(sort_order_condition).offset(0).take(TABLE_ROW_NUM)
      @spage = 1
    end
    @summaries_table = get_summary_table(summaries, @is_login_user)
    @total_summaries_num = @user.summaries.size
    logger.debug("summary num : #{@total_summaries_num}")
    
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

  def delete_article
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      article = login_user.user_articles.find_by_article_id(article_id)
      unless article == nil
        Article.find(article_id).remove_strength(get_login_user.id)
        article.destroy
      end
    end

    render_tab(params)
  end

  def delete_summary
    login_user = get_login_user
    params[:article_ids].each do |article_id|
      summary = login_user.summaries.find_by_article_id(article_id)
      unless summary == nil
        summary.destroy
      end
    end

    render_tab(params)
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

    render_tab(params)
  end

  def mark_as_unread
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      logger.debug("#{article_id}")
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.read_flg == true
        article.read_flg = false
        article.save
      end
    end

    render_tab(params)
  end

  def mark_as_favorite
    logger.debug("mark as favorite")
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      logger.debug("#{article_id}")
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.favorite_flg != true
        article.favorite_flg = true
        article.save
      end
    end

    render_tab(params)
  end

  def mark_off_favorite
    logger.debug("mark off favorite")
    login_user = get_login_user

    params[:article_ids].each do |article_id|
      logger.debug("#{article_id}")
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.favorite_flg == true
        article.favorite_flg = false
        article.save
      end
    end

    render_tab(params)
  end

  def clip
    login_user = get_login_user
    params[:article_ids].each do |article_id|
      if Article.exists?(article_id)
        login_user.user_articles.find_or_create_by(:user_id => get_login_user.id, :article_id => article_id)
      end
    end

    redirect_to :action => "index", :name => params[:name]
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

  def is_already_following?(user_id)
    is_already_following = false;
    if signed_in?
      if get_login_user.favorite_users.exists?(:favorite_user_id => user_id)
        is_already_following = true
      end
    end
    return is_already_following
  end

  def renew_sort_type(cookies, direction, sort)
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
        return {:menu_title => "Oldest", :condition => "created_at ASC"}
      else
        return {:menu_title => "Newest", :condition => "created_at DESC"}
      end
    else
      #default
      return {:menu_title => "Newest", :condition => "created_at DESC"}
    end
  end










  def get_table(user_articles, is_login_user)
    table = []

    user_articles.each do |user_article|
      if Article.exists?(user_article.article_id)
        article = user_article.article
        summary_num = article.summaries.size
        registered_num = article.user_articles.size
        registered_date = user_article.created_at

        is_registered = false
        is_already_read = false
        if signed_in? && is_login_user == false
          if get_login_user.user_articles.exists?(:article_id => user_article.article_id)
            is_registered = true
            is_already_read = get_login_user.user_articles.find_by_article_id(user_article.article_id).read_flg
          end
        end

        table_data = {:article => article, :summary_num => summary_num, 
                      :registered_num => registered_num, :registered_date  => registered_date, 
                      :is_registered => is_registered, :is_already_read => is_already_read}

        table.push(table_data)
      end
    end
    return table
  end

  def get_summary_table(summaries, is_login_user)
    table = []
    summaries.each do |summary|
      if Summary.exists?(summary.article_id)
        article = summary.article
        registered_num = article.user_articles.size
        last_updated = summary.updated_at
        like_num = summary.good_summaries.size
        summary_num = article.summaries.size

        is_registered = false
        is_already_read = false
        if signed_in? && is_login_user == false
          if get_login_user.user_articles.exists?(:article_id => summary.article_id)
            is_registered = true
            is_already_read = get_login_user.user_articles.find_by_article_id(summary.article_id).read_flg
          end
        end

        table_data = {:article => article, :summary_num => summary_num, 
                      :registered_num => registered_num, :last_updated => last_updated, 
                      :like_num => like_num, :is_registered => is_registered, :is_already_read => is_already_read}

        table.push(table_data)
      end
    end
    return table
  end

  def render_tab(params)
    if params[:mpage]
      redirect_to :action => "index", :mpage => params[:mpage]
    end
    if params[:spage]
      redirect_to :action => "index", :spage => params[:spage]
    end
    if params[:fpage]
      redirect_to :action => "index", :fpage => params[:fpage]
    end
    if params[:rpage]
      redirect_to :action => "index", :rpage => params[:rpage]
    end
  end

end
