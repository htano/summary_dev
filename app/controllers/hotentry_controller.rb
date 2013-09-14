class HotentryController < ApplicationController
  def index
    @entries = Article.getHotEntryArtileList
  end
end
