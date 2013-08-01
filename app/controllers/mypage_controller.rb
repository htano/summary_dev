class MypageController < ApplicationController
  def index
    user = U010User.find_by_user_name(params[:user_name])
    if user == nil then
      # TODO : no exsit account
    end
=begin
    # debub
    logger.debug("user_id    : #{user.user_id}")
    logger.debug("user_name  : #{user.user_name}")
    logger.debug("user_email : #{user.mail_addr}")
=end

    # main tab
    user_articles = R010UserArticle.find(:all, :conditions => {:user_id => user.user_id, :read_flg => false})
    articles = nil
    if user_articles != nil then
      user_articles.each do |user_article|
        #logger.debug("articles title : #{A010Article.find_by_article_id(user_article.article_id).article_title}")
        #articles += A010Article.find_by_article_id(user_article.article_id)
      end
    end

    render :layout => 'application', :locals => {:user => user, :articles => articles}
  end

end
