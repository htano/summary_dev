class SummaryListsController < ApplicationController
  NUM_OF_SUMMARY_AT_ONE_PAGE = 5
  def index
    logger.info("index start")

    #check current loginuser
    @article = Article.find_by id: params[:article_id]
    if @article == nil then
      logger.warn("article is null, pass to mypage");
      redirect_to :controller => "mypage", :action => "index" 
      return
    end
    @user = get_login_user

    @summary_list = Kaminari.paginate_array(@article.get_good_score_sorted_summary_list(@user))
                      .page(params[:page]).per(NUM_OF_SUMMARY_AT_ONE_PAGE)
    @is_read_article = @article.read?(@user)
    @article_preview = @article.get_contents_preview
    @num_of_mark_users = @article.get_marked_user
    @summary_by_me = @article.summaries.find_by user_id: @user 
    @is_read_later = @article.read_later?(@user) 
    @category_name = t('category.' + @article.get_category_name)
    @readers_list = @article.get_readers_list
  end

  def good_summary 
    logger.debug("start good_summary")
    unless get_login_user then
      redirect_to :controller => "consumer", :action => "index"
      logger.debug("end good_summary, pass to entrance")
      return	
    end


    unless GoodSummary.where(:user_id => get_login_user.id).where(:summary_id =>params[:summary_id]).exists?
      good_summary = GoodSummary.new(:user_id => get_login_user.id, :summary_id =>params[:summary_id]) 

      if good_summary.save
        logger.debug("success good_summary")
        @list_index = params[:list_index]
      else
        logger.error("ERROR good_summary")
      end 
    else
        logger.debug("good_summary already done")
        @list_index = params[:list_index]
    end 
    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
    logger.debug("end good_summary")
  end

  def goodSummaryAjax
    if !get_login_user
      render :text => 'To submit good summary, you should login.'
    else
      good_summary_pre = GoodSummary.where(['user_id = ? and summary_id = ?', get_login_user.id, params[:summary_id]])
      if good_summary_pre.count > 0
        if good_summary_pre.delete_all > 0
          render :text => 'cancel'
        else
          render :text => "Can't delete. Server Error has occured."
        end
      else
        good_summary_new = GoodSummary.new(:user_id => get_login_user.id, :summary_id =>params[:summary_id])
        if good_summary_new.save
          render :text => 'good'
        else
          render :text => "Can't add. Server Error has occured."
        end
      end
    end
  end

  def cancel_good_summary 
    logger.debug("start cancel_good_summary")
    unless get_login_user then
      redirect_to :controller => "consumer", :action => "index"
      logger.debug("end cancel_good_summary, pass to entrance")
      return	
    end

    GoodSummary.where(:user_id => get_login_user.id).
      where(:summary_id =>params[:summary_id]).delete_all 
    
    @list_index = params[:list_index]

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
    logger.debug("end cancel_good_summary")
  end

  def read 
    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end
    user_article_for_is_read=UserArticle.
      where(:user_id=>get_login_user.id).
      where(:article_id=>params[:article_id]).first

    if user_article_for_is_read then
      user_article_for_is_read.read_flg = true	
    else
      user_article_for_is_read = UserArticle.
        new(:user_id=>get_login_user.id,:article_id=>params[:article_id],:read_flg=>true)
    end

    if user_article_for_is_read.save
      logger.debug("success set reading mark")
    else
      logger.error("ERROR set reading mark")
    end

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
  end

  def cancel_read 
    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end

    user_article_for_is_read=
      UserArticle.where(:user_id=>get_login_user.id).
        where(:article_id=>params[:article_id]).first

    unless user_article_for_is_read == nil then
      user_article_for_is_read.read_flg = false
    else
      user_article_for_is_read=
        UserArticle.new(:user_id=>get_login_user.id,
                        :article_id=>params[:article_id],
                        :read_flg=>false)
    end

    if user_article_for_is_read.save
      logger.debug("success cancel reading mark!")
    else
      logger.error("ERROR cancel reading mark!")
    end
    
    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end

  end


  def follow
    logger.debug("start follow")

    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end
    
    @list_index = params[:list_index]

    if FavoriteUser.create(:user_id => get_login_user.id, 
                        :favorite_user_id => params[:follow_user_id])
      logger.debug("success follow")
    else
      logger.error("ERROR follow")
    end

    user_id = params[:follow_user_id]
    # for renewing followers number on profile view

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
    logger.debug("end follow")
  end

  def unfollow
    logger.debug("star unfollow")

    if get_login_user == nil then
      logger.fatal("ERROR nil user push unfollow!")
      redirect_to :controller => "consumer", :action => "index"
      return	
    end

    @list_index = params[:list_index]

    current_user = get_login_user

    if current_user && current_user.favorite_users.exists?(:favorite_user_id => params[:unfollow_user_id])
      current_user.favorite_users.find_by_favorite_user_id(params[:unfollow_user_id]).destroy
      logger.debug("success unfollow")
    else
      logger.error("ERROR unfollow")
    end 

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
    logger.debug("end unfollow")
  end


  def read_later 
    logger.debug("read_later" )

    if get_login_user == nil then
      redirect_to :controller => "consumer", :action => "index"
      return	
    end
    
    add_webpage(Article.find_by_id(params[:article_id]).url)

    respond_to do |format|
      format.html { redirect_to :action => "index", :name => User.find(@user_id).name }
      format.js
    end
    logger.debug("end read_later")
  end

  def cancel_read_later 
    logger.debug("start cancel_read_later")

    if get_login_user == nil then
      logger.fatal("ERROR nil user push cancel_read_later!")
      redirect_to :controller => "consumer", :action => "index"
      return	
    end

    remove_webpage(params[:article_id])
    
    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
    logger.debug("end cancel_read_later")
  end
end
