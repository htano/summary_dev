class MypageController < ApplicationController
  def index
    logger.debug("action index")
    @user = U010User.find_by_user_name(params[:user_name])
    if @user == nil then
      # FIXME : ベタ書きでreturnより、関数を一つ定義してそこにredirect_toで飛ばすほうがよろしい気がする
      logger.debug("exit no account")
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html'
      return
    end
=begin
    # debub
    logger.debug("user_id    : #{@user.user_id}")
    logger.debug("user_name  : #{@user.user_name}")
    logger.debug("user_email : #{@user.mail_addr}")
=end
    # FIXME : read_flgをみないでuser_idに引っかかるデータを一気に取ってきてlocalでread_flg判断して振り分けたほうが速いかも
    # main tab
    user_articles = R010UserArticle.where(:u010_user_id => @user.user_id, :read_flg => false)
    @articles = []
    @main_summaries_num = []
    unless user_articles == nil then
      articles_num = user_articles.size
      @articles = Array.new(articles_num)
      user_articles.each_with_index do |user_article, i|
        @articles[i] = A010Article.find_by_article_id(user_article.article_id)
        @main_summaries_num[i] = S010Summary.count(:all, :conditions => {:article_id => user_article.article_id})
=begin
        logger.debug("i : #{i}")
        logger.debug("artile_id : #{articles[i].article_id}")
=end
      end
    end

    # edited summary tab
    user_edited_summaries = S010Summary.where(:u010_user_id => @user.user_id)
    @edited_summaries = []
    @like_num = []
    unless user_edited_summaries == nil then
      edited_sum_num = user_edited_summaries.size
      @edited_summaries = Array.new(edited_sum_num)
      user_edited_summaries.each_with_index do |edited_summary, i|
        @edited_summaries[i] = A010Article.find_by_article_id(edited_summary.article_id)
        @like_num[i] = S011GoodSummary.count(:all, :conditions => {:summary_id => edited_summary.summary_id})
      end
    end
    # favorite tab
    # read tab
    user_read_articles = R010UserArticle.where(:u010_user_id => @user.user_id, :read_flg => true)
    @read_articles = []
    @read_summaries_num = []
    unless user_read_articles == nil then
      read_articles_num = user_read_articles.size
      @read_articles = Array.new(read_articles_num)
      user_read_articles.each_with_index do |user_read_article, i|
        @read_articles[i] = A010Article.find_by_article_id(user_read_article.article_id)
        @read_summaries_num[i] = S010Summary.count(:all, :conditions => {:article_id => user_read_article.article_id})
      end
    end

    render :layout => 'application', :locals => {:user => @user}
  end

  def delete
    delete_mode = params[:delete_mode]
    logger.debug("delete_mode : #{delete_mode}")
    if delete_mode.to_i == 2 then
      summary = S010Summary.find(:first, :conditions => {:u010_user_id => params[:user_id], :article_id => params[:article_id]})
      unless summary == nil
        logger.debug("not nil")
        summary.destroy
      else
        logger.debug("nil nil")
      end
    else
      article = R010UserArticle.find(:first, :conditions => {:u010_user_id => params[:user_id], :article_id => params[:article_id]})
      unless article == nil
        article.destroy
      end
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

  def destroy
    @user = U010User.find_by_user_name(params[:user_name]).destroy
    render :nothing => true
  end
end
