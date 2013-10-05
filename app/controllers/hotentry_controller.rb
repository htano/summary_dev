class HotentryController < ApplicationController
  def index
    @entries = Article.get_hotentry_articles
  end

  def normal
    @entries = Article.get_hotentry_articles
  end

  def small
    @order = 1
    @hash = {}
    @entries = Article.get_hotentry_articles
    @entries.each do |e|
      @hash[e.id] = @order
      @order += 1
    end
  end

  def large
    @entries = Article.get_hotentry_articles
  end
end
