class HotentryController < ApplicationController
  def index
    case cookies[:hotentry_view_type]
    when 'small'
      redirect_to(:action => 'small')
    when 'large'
      redirect_to(:action => 'large')
    else
      redirect_to(:action => 'normal')
    end
  end

  def normal
    cookies[:hotentry_view_type] = { :value => 'normal' }
    @entries = Article.get_hotentry_articles
  end

  def small
    cookies[:hotentry_view_type] = { :value => 'small' }
    @order = 1
    @hash = {}
    @entries = Article.get_hotentry_articles
    @entries.each do |e|
      @hash[e.id] = @order
      @order += 1
    end
  end

  def large
    cookies[:hotentry_view_type] = { :value => 'large' }
    @entries = Article.get_hotentry_articles
  end
end
