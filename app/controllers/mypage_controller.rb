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
        redirect_to :controller => 'consumer', :action => 'index'
        return
      end
    end

    if @is_login_user then
      @user = User.find_by_name(get_current_user_name)
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

    # whether user has a photo or no
    @is_photo_data = @user.prof_image != nil ? true : false;

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

    # main tab & read tab
    @articles = []
    @read_articles = []
    @main_summaries_num = []
    @read_summaries_num = []
    @user.user_articles.each do |user_article|
      article = Article.find(user_article.article_id)
      summary_num = Summary.count(:all, :conditions => {:article_id => user_article.article_id})

      if user_article.read_flg then
        @read_articles.push(article)
        @read_summaries_num.push(summary_num)
      else
        @articles.push(article)
        @main_summaries_num.push(summary_num)
      end

    end

    # edited summary tab
    @edited_summaries = []
    @like_num = []
    @user.summaries.each do |summary|
      logger.debug("summary_id : #{summary.id}")
      article = Article.find(summary.article_id)
      @edited_summaries.push(article)

      like = GoodSummary.count(:all, :conditions => {:summary_id => summary.id})
      @like_num.push(like)
    end

    # favorite tab

    render :layout => 'application'
  end

  def delete
    delete_mode = params[:delete_mode]
    logger.debug("delete_mode : #{delete_mode}")
    if delete_mode.to_i == 2 then
      summary = Summary.find(:first, 
        :conditions => {:user_id => params[:user_id], :article_id => params[:article_id]})
      unless summary == nil
        summary.destroy
      end
    else
      article = UserArticle.find(:first, 
        :conditions => {:user_id => params[:user_id], :article_id => params[:article_id]})
      unless article == nil
        article.destroy
      end
    end
    redirect_to :action => "index"
  end

  def reverse_read_flg
    article = UserArticle.find(:first, 
      :conditions => {:user_id => params[:user_id], :article_id => params[:article_id]})

    if article then
      article.read_flg = !article.read_flg
      article.save
    end

    redirect_to :action => "index"
  end

  def follow
    logger.debug("follow")
    @current_user = getLoginUser

    if @current_user then
      # TODO : error handle
      FavoriteUser.create(:user_id => @current_user.id, :favorite_user_id => params[:follow_user_id])
    end

    @user_id = params[:follow_user_id]
    # for renewing followers number on profile view
    @follower_num = "followers" + "<br>" + 
                    FavoriteUser.count(:all, :conditions => {:favorite_user_id => params[:follow_user_id]}).to_s

  end

  def unfollow
    logger.debug("unfollow")
    @current_user = getLoginUser

    if @current_user && @current_user.favorite_users.exists?(:favorite_user_id => params[:unfollow_user_id]) then
      @current_user.favorite_users.find_by_favorite_user_id(params[:unfollow_user_id]).destroy
    end

    @user_id = params[:unfollow_user_id]
    @follower_num = "followers" + "<br>" + 
                    FavoriteUser.count(:all, :conditions => {:favorite_user_id => params[:unfollow_user_id]}).to_s

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
