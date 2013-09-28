# encoding: utf-8

class SearchController < ApplicationController
  #初期表示
  def index
  end

  #タグで検索
  #TODO 複数タグを指定された時の挙動
  def search_by_tag
    @searchtext = "#{params[:searchtext]}"
    @articles = Article.search_by_tag(@searchtext)
    render :template => "search/index"
  end

  #本文で検索
  def search_by_content
  end

  #タイトルで検索
  def search_by_title
  end
end
