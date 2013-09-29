class SummaryListsController < ApplicationController
  #TODO 画面からURL直打ちの回避
  def get_summary_num_for_chrome_extension
    @url = "#{params[:url]}"
    article = Article.find_by_url(@url);
    if article != nil then
      summary_num = Summary.count(:all, :conditions => {:article_id => article.id})
      render :text => summary_num and return
    else
      render :text => 0 and return
    end
  end

  def get_summary_list_for_chrome_extension
    @url = "#{params[:url]}"
    article = Article.find_by_url(@url);
    if article == nil then
      render :json => nil and return
    else
      summaries = article.summaries.find(:all,:limit => 10)
      if summaries != nil then
        render :json => summaries and return
      else
        render :json => nil and return
      end
    end
  end

  def index
    logger.info("summary_list controller:index start")

    #check current loginuser
    @article = Article.find_by id: params[:articleId]
    if @article == nil then
      logger.warning("article is null, pass to mypage");
      redirect_to :controller => "mypage", :action => "index" 
      return
    end
    @user = getLoginUser
    @summaryList = @article.getSortedSummaryList(@user)
    @isReadArticle = @article.isRead(@user)
    @numOfMarkUsers = @article.getMarkedUser
    @summaryByMe = @article.summaries.find_by user_id: @user 
  end

  def goodSummary 
    if getLoginUser == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end
    goodSummary = GoodSummary.new(:user_id => getLoginUser.id, :summary_id =>params[:summaryId]) 

    if goodSummary.save
      @listIndex = params[:listIndex]
      render
    end
  end

  def goodSummaryAjax
    if !getLoginUser
      render :text => 'To submit good summary, you should login.'
    else
      good_summary_pre = GoodSummary.where(['user_id = ? and summary_id = ?', getLoginUser.id, params[:summaryId]])
      if good_summary_pre.count > 0
        if good_summary_pre.delete_all > 0
          render :text => 'cancel'
        else
          render :text => "Can't delete. Server Error has occured."
        end
      else
        good_summary_new = GoodSummary.new(:user_id => getLoginUser.id, :summary_id =>params[:summaryId])
        if good_summary_new.save
          render :text => 'good'
        else
          render :text => "Can't add. Server Error has occured."
        end
      end
    end
  end

  def cancelGoodSummary 
    if getLoginUser == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end

    GoodSummary.where(:user_id => getLoginUser.id).where(:summary_id =>params[:summaryId]).delete_all 
    @listIndex = params[:listIndex]
    render
  end

  def isRead 
    if getLoginUser == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end
    userArticleForIsRead=UserArticle.where(:user_id=>getLoginUser.id).where(:article_id=>params[:articleId]).first

    unless userArticleForIsRead == nil then
      userArticleForIsRead.read_flg = true	
    else
      userArticleForIsRead=UserArticle.new(:user_id=>getLoginUser.id,:article_id=>params[:articleId],:read_flg=>true)
    end

    if userArticleForIsRead.save
      render

    else
    end
  end

  def cancelIsRead 
    if getLoginUser == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end

    userArticleForIsRead=
      UserArticle.where(:user_id=>getLoginUser.id).where(:article_id=>params[:articleId]).first

    unless userArticleForIsRead == nil then
      userArticleForIsRead.read_flg = false
    else
      userArticleForIsRead=
        UserArticle.new(:user_id=>getLoginUser.id,
                        :article_id=>params[:articleId],
                        :read_flg=>false)
    end

    if userArticleForIsRead.save
      render
    else

    end

  end


  def follow
    logger.debug("follow")

    unless signed_in?
      # TODO : ログインしてなかった時
    end

    current_user = getLoginUser

    if current_user
      # TODO : error handle
      FavoriteUser.create(:user_id => current_user.id, :favorite_user_id => params[:follow_user_id])
    end

    user_id = params[:follow_user_id]
    # for renewing followers number on profile view
    follower_num = "followers" + "<br>" + 
      FavoriteUser.count(:all, :conditions => {:favorite_user_id => params[:follow_user_id]}).to_s

    respond_to do |format|
      format.html { redirect_to :action => "index", :name => User.find(@user_id).name }
      format.js
    end
  end

  def unfollow
    logger.debug("unfollow")

    current_user = getLoginUser

    if current_user && current_user.favorite_users.exists?(:favorite_user_id => params[:unfollow_user_id])
      current_user.favorite_users.find_by_favorite_user_id(params[:unfollow_user_id]).destroy
    end

    user_id = params[:unfollow_user_id]

    respond_to do |format|
      format.html { redirect_to :action => "index", :name => User.find(@user_id).name }
      format.js
    end
  end


end
