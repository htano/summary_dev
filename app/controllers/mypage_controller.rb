class MypageController < ApplicationController
  def index
    logger.debug("action index")

    # check wheter user accessed to this action is signed in user or not
    if params[:name] then
      if isLoginUser?(params[:name]) then
        @is_login_user = true
      else
        @is_login_user = false
      end
    else
      if signed_in? then
        @is_login_user = true
      else
        redirect_to :controller => 'consumer', :action => 'index' and return
      end
    end

    if @is_login_user then
      @user = User.find_by_name(get_current_user_name)
      @user.updateMypageAccess
    else
      @user = User.find_by_name(params[:name])
      if @user then
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
    @articles = []
    @favorite_articles = []
    @read_articles = []

    @main_summaries_num     = []
    @favorite_summaries_num = []
    @read_summaries_num     = []

    @user.user_articles.each do |user_article|
      article = Article.find(user_article.article_id)
      summary_num = Summary.count(:all, :conditions => {:article_id => user_article.article_id})

      if user_article.favorite_flg then
        @favorite_articles.push(article)
        @favorite_summaries_num.push(summary_num)
      end
      if user_article.read_flg then
        @read_articles.push(article)
        @read_summaries_num.push(summary_num)
      else
        @articles.push(article)
        @main_summaries_num.push(summary_num)
      end

    end

    # summary tab
    @summaries = []
    @like_num = []
    @user.summaries.each do |summary|
      logger.debug("summary_id : #{summary.id}")
      article = Article.find(summary.article_id)
      @summaries.push(article)

      like = GoodSummary.count(:all, :conditions => {:summary_id => summary.id})
      @like_num.push(like)
    end

    render :layout => 'application'
  end

  def delete_article
    login_user = getLoginUser

    params[:article_ids].each do |article_id|
      article = login_user.user_articles.find_by_article_id(article_id)
      unless article == nil
        article.destroy
      end
    end

    redirect_to :action => "index"
  end

  def delete_summary
    login_user = getLoginUser
    params[:article_ids].each do |article_id|
      summary = login_user.summaries.find_by_article_id(article_id)
      unless summary == nil
        summary.destroy
      end
    end

    redirect_to :action => "index"
  end

  def mark_as_read
    login_user = getLoginUser

    params[:article_ids].each do |article_id|
      logger.debug("#{article_id}")
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.read_flg != true then
        article.read_flg = true
        article.save
      end
    end

    redirect_to :action => "index"
  end

  def mark_as_unread
    login_user = getLoginUser

    params[:article_ids].each do |article_id|
      logger.debug("#{article_id}")
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.read_flg == true then
        article.read_flg = false
        article.save
      end
    end

    redirect_to :action => "index"
  end

  def mark_as_favorite
    logger.debug("mark as favorite")
    login_user = getLoginUser

    params[:article_ids].each do |article_id|
      logger.debug("#{article_id}")
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.favorite_flg != true then
        article.favorite_flg = true
        article.save
      end
    end

    redirect_to :action => "index"
  end

  def mark_as_unfavorite
    logger.debug("mark as unfavorite")
    login_user = getLoginUser

    params[:article_ids].each do |article_id|
      logger.debug("#{article_id}")
      article = login_user.user_articles.find_by_article_id(article_id)

      if article && article.favorite_flg == true then
        article.favorite_flg = false
        article.save
      end
    end

    redirect_to :action => "index"
  end

  def clip
    logger.debug("clip")

    unless signed_in? then
      redirect_to :controller => 'consumer', :action => 'index' and return
    end

    login_user = getLoginUser
    params[:article_ids].each do |article_id|
      unless login_user.user_articles.exists?(:user_id => getLoginUser.id, :article_id => article_id) then
        UserArticle.create(:user_id => getLoginUser.id, :article_id => article_id)
      end
    end

    redirect_to :action => "index"
  end

  def follow
    logger.debug("follow")

    unless signed_in? then
      # TODO : ログインしてなかった時
    end
    
    @current_user = getLoginUser

    if @current_user then
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
    # FIXME : ログインしてない状態で来た時にログイン画面に飛ばす? そもそも、その状況はない

    @current_user = getLoginUser

    if @current_user && @current_user.favorite_users.exists?(:favorite_user_id => params[:unfollow_user_id]) then
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
    if signed_user && signed_user.favorite_users.exists?(:favorite_user_id => user.id) then
      is_already_following = true
    else
      is_already_following = false
    end
    return is_already_following
  end

end
