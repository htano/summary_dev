class ArticleListsController < ApplicationController
  def list_by_tag
    @tag = "#{params[:tag]}"
    @articles = Article.get_list_by_tag(@tag)
  end
end
