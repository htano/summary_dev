class MypageController < ApplicationController
  def index
    logger.debug("action index")
    @user = U010User.find_by_user_name(params[:user_name])
    if @user == nil then
      # TODO : no exsit account
      logger.debug("exit no account")
    end
=begin
    # debub
    logger.debug("user_id    : #{@user.user_id}")
    logger.debug("user_name  : #{@user.user_name}")
    logger.debug("user_email : #{@user.mail_addr}")
=end
    # FIXME : read_flgをみないでuser_idに引っかかるデータを一気に取ってきてlocalでread_flg判断して振り分けたほうが速いかも
    # main tab
    user_articles = R010UserArticle.where(:user_id => @user.user_id, :read_flg => false)
    @articles = nil
    unless user_articles == nil then
      articles_num = user_articles.size
      @articles = Array.new(articles_num)
      i = 0
      user_articles.each do |user_article|
        @articles[i] = A010Article.find_by_article_id(user_article.article_id)
        i += 1
=begin
        logger.debug("i : #{i}")
        logger.debug("artile_id : #{articles[i].article_id}")
=end
      end
    end

    # edited summary tab
    # favorite tab
    # read tab
    user_read_articles = R010UserArticle.where(:user_id => @user.user_id, :read_flg => true)
    @read_articles = nil
    unless user_read_articles == nil then
      read_articles_num = user_read_articles.size
      @read_articles = Array.new(read_articles_num)
      i = 0
      user_read_articles.each do |user_read_article|
        @read_articles[i] = A010Article.find_by_article_id(user_read_article.article_id)
        i += 1
      end
    end

    render :layout => 'application', :locals => {:user => @user}
  end

  def delete
    article = R010UserArticle.find(:first, :conditions => {:user_id => params[:user_id], :article_id => params[:article_id]})
    unless article == nil
      article.destroy
    end
    redirect_to :action => "index", :params => {:user_name => params[:user_name]}
  end

  def mark_as_read
=begin
    logger.debug("mark_as_read")
    logger.debug("user_id = #{params[:user_id]}, article_id = #{params[:article_id]}")
=end
    article = R010UserArticle.find(:first, :conditions => {:user_id => params[:user_id], :article_id => params[:article_id]})
    if article.read_flg then
#      logger.debug("read flag is true")
    else
#      logger.debug("read flag is false")
      article.read_flg = true
      article.save
    end

    redirect_to :action => "index", :params => {:user_name => params[:user_name]}
  end
end
