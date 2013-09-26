class ArticleListsController < ApplicationController
  def index
  end

  def listByTag
  	@tag = "#{params[:tag]}"
  	@articles = Article.getListByTag(@tag)
  end
end
