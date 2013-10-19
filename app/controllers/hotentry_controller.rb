class HotentryController < ApplicationController
  def index
    case cookies[:hotentry_view_type]
    when 'small'
      redirect_to(:action => 'small', 
                  :category => params[:category])
    when 'large'
      redirect_to(:action => 'large',
                  :category => params[:category])
    else
      redirect_to(:action => 'normal',
                  :category => params[:category])
    end
  end

  def normal
    if params[:category]
      @category_name = params[:category]
    else
      @category_name = 'all'
    end
    cookies[:hotentry_view_type] = { :value => 'normal' }
    @entries = Article.get_hotentry_articles(@category_name)
  end

  def small
    if params[:category]
      @category_name = params[:category]
    else
      @category_name = 'all'
    end
    cookies[:hotentry_view_type] = { :value => 'small' }
    @order = 1
    @hash = {}
    @entries = Article.get_hotentry_articles(@category_name)
    @entries.each do |e|
      @hash[e.id] = @order
      @order += 1
    end
  end

  def large
    if params[:category]
      @category_name = params[:category]
    else
      @category_name = 'all'
    end
    cookies[:hotentry_view_type] = { :value => 'large' }
    @entries = Article.get_hotentry_articles(@category_name)
  end
end
