class MypageController < ApplicationController
  def index
    logger.debug("action index")

    # check wheter user accessed to this action is signed in user or not
    if params[:name]
      if login_user?(params[:name])
        @is_login_user = true
      else
        @is_login_user = false
      end
    else
      if signed_in?
        @is_login_user = true
      else
        redirect_to :controller => 'consumer', :action => 'index' and return
      end
    end

    if @is_login_user
      @user = User.find_by_name(get_current_user_name)
      @user.update_mypage_access
    else
      @user = User.find_by_name(params[:name])
      if @user
        # check whether already follows or not
        @is_already_following = is_already_following(@user)
      else
        # error account doesn't exist
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html'
        return
      end
    end

    # follow user information
    @favorite_users = []
    @user.favorite_users.each do |favorite_user|
#      logger.debug("favorite_user_id : #{favorite_user.favorite_user_id}")
      user = User.find(favorite_user.favorite_user_id)
      @favorite_users.push(user)
    end

    # followers 
    followers_favorite_users = FavoriteUser.where(:favorite_user_id => @user.id)
    @followers = []
    followers_favorite_users.each do |follower_favorite_user|
      user = follower_favorite_user.user
      @followers.push(user)
    end

    # main tab & favorite tab & read tab
    @main_articles_table = []
    @mpage = params[:mpage] ? params[:mpage] : 1
    @mpage = @mpage.to_i > 1 ? @mpage : 1
    offset = (@mpage.to_i - 1) * 10
    user_articles = @user.user_articles.reverse_order.offset(offset).unread.take(10)
    if user_articles.size == 0
      user_articles = @user.user_articles.reverse_order.offset(0).unread.take(10)
      @mpage = 1
    end
    @main_articles_table = get_table(user_articles, @is_login_user)
    @total_main_articles_num = @user.user_articles.unread.size

    @favorite_articles_table = []
    @fpage = params[:fpage] ? params[:fpage] : 1
    @fpage = @fpage.to_i > 1 ? @fpage : 1
    offset = (@fpage.to_i - 1) * 10
    user_articles = @user.user_articles.reverse_order.offset(offset).favorite.take(10)
    if user_articles.size == 0
      user_articles = @user.user_articles.reverse_order.offset(0).favorite.take(10)
      @fpage = 1
    end
    @favorite_articles_table = get_table(user_articles, @is_login_user)
    @total_favorite_articles_num = @user.user_articles.favorite.size

    @read_articles_table = []
    @rpage = params[:rpage] ? params[:rpage] : 1
    @rpage = @rpage.to_i > 1 ? @rpage : 1
    offset = (@rpage.to_i - 1) * 10
    user_articles = @user.user_articles.reverse_order.offset(offset).read.take(10)
    if user_articles.size == 0
      user_articles = @user.user_articles.reverse_order.offset(0).read.take(10)
      @rpage = 1
    end
    @read_articles_table = get_table(user_articles, @is_login_user)
    @total_read_articles_num = @user.user_articles.read.size
    
    # summary tab
    @summaries_table = []
    @spage = params[:spage] ? params[:spage] : 1
    @spage = @spage.to_i > 1 ? @spage : 1
    offset = (@spage.to_i - 1) * 10
    summaries = @user.summaries.reverse_order.offset(offset).take(10)
    if summaries.size == 0
      summaries = @user.summaries.reverse_order.offset(0).take(10)
      @spage = 1
    end
    @summaries_table = get_summary_table(summaries, @is_login_user)
    @total_summaries_num = @user.summaries.size
    
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
      logger.debug("#{article_id}")
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
    logger.debug("clip")

    unless signed_in?
      redirect_to :controller => 'consumer', :action => 'index' and return
    end

    login_user = get_login_user
    params[:article_ids].each do |article_id|
      login_user.user_articles.find_or_create_by(:user_id => get_login_user.id, :article_id => article_id)
    end

    redirect_to :action => "index", :name => params[:name]
  end

  def follow
    logger.debug("follow")

    unless signed_in?
      # TODO : ログインしてなかった時
    end
    
    @current_user = get_login_user

    if @current_user
      # TODO : error handle
      FavoriteUser.create(:user_id => @current_user.id, :favorite_user_id => params[:follow_user_id])
    end

    @user_id = params[:follow_user_id]
    # for renewing followers number on profile view
    @follower_num = "followers" + "<br>" + 
                    FavoriteUser.count(:all, :conditions => {:favorite_user_id => params[:follow_user_id]}).to_s

    respond_to do |format|
      format.html { redirect_to :action => "index", :name => User.find(@user_id).name }
      format.js
    end
  end

  def unfollow
    logger.debug("unfollow")

    @current_user = get_login_user

    if @current_user && @current_user.favorite_users.exists?(:favorite_user_id => params[:unfollow_user_id])
      @current_user.favorite_users.find_by_favorite_user_id(params[:unfollow_user_id]).destroy
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
  def is_already_following(user)
    is_already_following = false
    signed_user = User.find_by_name(get_current_user_name)
    if signed_user && signed_user.favorite_users.exists?(:favorite_user_id => user.id)
      is_already_following = true
    else
      is_already_following = false
    end
    return is_already_following
  end

  def get_table(user_articles, is_login_user)
    table = []

    user_articles.each do |user_article|
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

      table_data = {:article => article, :summary_num => summary_num, :registered_num => registered_num, :registered_date => registered_date, :is_registered => is_registered, :is_already_read => is_already_read}

      table.push(table_data)
    end
    return table
  end

  def get_summary_table(summaries, is_login_user)
    table = []
    summaries.each do |summary|
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

      table_data = {:article => article, :summary_num => summary_num, :registered_num => registered_num, :last_updated => last_updated, :like_num => like_num, :is_registered => is_registered, :is_already_read => is_already_read}

      table.push(table_data)
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
