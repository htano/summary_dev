class MypageController < ApplicationController
  def index
    logger.debug("action index")

    if params[:name] then
      @is_login_user = false
      @user = User.find_by_name(params[:name])
    else
      @is_login_user = true
      @user = User.find_by_name(get_current_user_name)
    end

    if @user == nil then
      # FIXME : ベタ書きでreturnより、関数を一つ定義してそこにredirect_toで飛ばすほうがよろしい気がする
      logger.debug("exit no account")
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html'
      return
    end
=begin
    # debug
    logger.debug("user_id    : #{@user.user_id}")
    logger.debug("user_name  : #{@user.user_name}")
    logger.debug("user_email : #{@user.mail_addr}")
=end

    # whether user has a photo or no
    @is_photo_data = @user.prof_image != nil ? true : false;

    # follow user information
    @favorite_users = []
    @user.favorite_users.each do |favorite_user|
#      logger.debug("favorite_user_id : #{favorite_user.favorite_user_id}")
      user = User.find(favorite_user.favorite_user_id)
      @favorite_users.push(user)
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

    render :layout => 'application', :locals => {:user => @user}
  end

  def delete
    delete_mode = params[:delete_mode]
    logger.debug("delete_mode : #{delete_mode}")
    if delete_mode.to_i == 2 then
      summary = Summary.find(:first, 
        :conditions => {:user_id => params[:user_id], :article_id => params[:article_id]})
      unless summary == nil
        # logger.debug("not nil")
        summary.destroy
      else
        # logger.debug("nil nil")
      end
    else
      article = UserArticle.find(:first, 
        :conditions => {:user_id => params[:user_id], :article_id => params[:article_id]})
      unless article == nil
        article.destroy
      end
    end
    redirect_to :action => "index", :params => {:name => params[:name]}
  end

  def mark_as_read
    article = UserArticle.find(:first, 
      :conditions => {:user_id => params[:user_id], :article_id => params[:article_id]})
    if article.read_flg then
    else
      article.read_flg = true
      article.save
    end

    redirect_to :action => "index", :params => {:name => params[:name]}
  end

  def destroy
    @user = User.find_by_name(params[:name]).destroy
    render :nothing => true
  end

end
