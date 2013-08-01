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
    user_articles = R010UserArticle.where(:user_id => user.user_id, :read_flg => false)
    articles = nil
    unless user_articles == nil then
      articles_num = user_articles.size
      articles = Array.new(articles_num)
      i = 0
      user_articles.each do |user_article|
        articles[i] = A010Article.find_by_article_id(user_article.article_id)
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
    user_read_articles = R010UserArticle.where(:user_id => user.user_id, :read_flg => true)
    read_articles = nil
    unless user_read_articles == nil then
      read_articles_num = user_read_articles.size
      read_articles = Array.new(read_articles_num)
      i = 0
      user_read_articles.each do |user_read_article|
        read_articles[i] = A010Article.find_by_article_id(user_read_article.article_id)
        i += 1
      end
    end

    render :layout => 'application', :locals => {:user => user, :articles => articles, :read_articles => read_articles}
  end
end
