# encoding: utf-8

class SearchController < ApplicationController
  #初期表示
  def index
    @condition = 1
    @sort = 1
    @focus = 1
  end

  def search
    @searchtext = "#{params[:searchtext]}"
    @condition = "#{params[:condition]}"
    @sort = "#{params[:sort]}"
    @focus = "#{params[:sort]}"
    p @condition
    case @condition
    when "1"
      search_by_tag(@searchtext)
    when "2"
      search_by_title(@searchtext)
    when "3"
      search_by_content(@searchtext)
    else
      redirect_to :controller => "search", :action => "index"
    end    
  end

  #タグで検索
  #TODO 複数タグを指定された時の挙動
  def search_by_tag(searchtext)
    @articles = Article.search_by_tag(searchtext)
    render :template => "search/index"
  end

  #タイトルで検索
  def search_by_title(searchtext)
    @articles = Article.search_by_title(searchtext)
    render :template => "search/index"
  end

  #本文で検索
  def search_by_content(searchtext)
    @articles = Article.search_by_content(searchtext)
    render :template => "search/index"
  end
end
