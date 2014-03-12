class RedirectorController < ApplicationController
  def original_page
    aid = params[:article_id]
    article = Article.find(aid)
    if article && article.url
      if signed_in?
        get_login_user.add_cluster_id(article.cluster_id, 0.1)
      end
      redirect_to article.url
    end
  end
end
