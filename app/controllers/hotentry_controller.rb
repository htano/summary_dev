class HotentryController < ApplicationController
  def index
    @entries = Article.get_hotentry_articles
  end
end
