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
    logger.info("index start")

    #check current loginuser
    @article = Article.find_by id: params[:articleId]
    if @article == nil then
      logger.warning("article is null, pass to mypage");
      redirect_to :controller => "mypage", :action => "index" 
      return
    end
    @user = get_login_user
    @summaryList = @article.getSortedSummaryList(@user)
    @isReadArticle = @article.isRead(@user)
    @numOfMarkUsers = @article.getMarkedUser
    @summaryByMe = @article.summaries.find_by user_id: @user 
  end

  def goodSummary 
    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end
    goodSummary = GoodSummary.new(:user_id => get_login_user.id, :summary_id =>params[:summaryId]) 

    if goodSummary.save
      @listIndex = params[:listIndex]
    end

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
  end

  def goodSummaryAjax
    if !get_login_user
      render :text => 'To submit good summary, you should login.'
    else
      good_summary_pre = GoodSummary.where(['user_id = ? and summary_id = ?', get_login_user.id, params[:summaryId]])
      if good_summary_pre.count > 0
        if good_summary_pre.delete_all > 0
          render :text => 'cancel'
        else
          render :text => "Can't delete. Server Error has occured."
        end
      else
        good_summary_new = GoodSummary.new(:user_id => get_login_user.id, :summary_id =>params[:summaryId])
        if good_summary_new.save
          render :text => 'good'
        else
          render :text => "Can't add. Server Error has occured."
        end
      end
    end
  end

  def cancelGoodSummary 
    logger.debug("cancel good summary")
    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end

    GoodSummary.where(:user_id => get_login_user.id).
      where(:summary_id =>params[:summaryId]).delete_all 
    
    @listIndex = params[:listIndex]

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
  end

  def isRead 
    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end
    userArticleForIsRead=UserArticle.
      where(:user_id=>get_login_user.id).
      where(:article_id=>params[:articleId]).first

    unless userArticleForIsRead == nil then
      userArticleForIsRead.read_flg = true	
    else
      userArticleForIsRead=UserArticle.
        new(:user_id=>get_login_user.id,:article_id=>params[:articleId],:read_flg=>true)
    end

    if userArticleForIsRead.save
      logger.debug("Success set reading mark")
    else
      logger.error("ERROR set reading mark")
    end

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
  end

  def cancelIsRead 
    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end

    userArticleForIsRead=
      UserArticle.where(:user_id=>get_login_user.id).
        where(:article_id=>params[:articleId]).first

    unless userArticleForIsRead == nil then
      userArticleForIsRead.read_flg = false
    else
      userArticleForIsRead=
        UserArticle.new(:user_id=>get_login_user.id,
                        :article_id=>params[:articleId],
                        :read_flg=>false)
    end

    if userArticleForIsRead.save
      logger.debug("Success cancel reading mark!")
    else
      logger.error("ERROR cancel reading mark!")
    end
    
    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end

  end


  def follow
    logger.debug("follow")

    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end
    
    @listIndex = params[:listIndex]

    if FavoriteUser.create(:user_id => get_login_user.id, 
                        :favorite_user_id => params[:follow_user_id])
      logger.debug("Success follow")
    else
      logger.error("ERROR follow")
    end

    user_id = params[:follow_user_id]
    # for renewing followers number on profile view

    respond_to do |format|
      format.html { redirect_to :action => "index", :name => User.find(@user_id).name }
      format.js
    end
  end

  def unfollow
    logger.debug("unfollow")

    if get_login_user == nil then
      logger.fatal("ERROR nil user push unfollow!")
      redirect_to :controller => "consumer", :action => "index"
      return	
    end

    @listIndex = params[:listIndex]

    current_user = get_login_user

    if current_user && current_user.favorite_users.exists?(:favorite_user_id => params[:unfollow_user_id])
      current_user.favorite_users.find_by_favorite_user_id(params[:unfollow_user_id]).destroy

    end

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
  end


end
