class HotentryController < ApplicationController
  def index
    case cookies[:hotentry_view_type]
    when 'small'
      small
      @view_type = 'small'
      render :template => 'hotentry/small'
    when 'large'
      large
      @view_type = 'large'
      render :template => 'hotentry/large'
    else
      normal
      @view_type = 'normal'
      render :template => 'hotentry/normal'
    end
  end

  def normal
    unless action_name == 'index'
      cookies[:hotentry_view_type] = { :value => 'normal' }
      redirect_to(:action => 'index',
                  :category => params[:category])
    end
    if params[:category]
      @category_name = params[:category]
    else
      @category_name = 'personal'
    end
    cookies[:hotentry_view_type] = { :value => 'normal' }
    if @category_name == 'personal'
      @entries = Article.get_personal_hotentry(get_login_user)
    else
      @entries = Article.get_hotentry_articles(@category_name)
    end
    @entries = Kaminari.paginate_array(@entries).page(
      params[:page]
    ).per(Article::HOTENTRY_DISPLAY_NUM_NORMAL)
  end

  def small
    unless action_name == 'index'
      cookies[:hotentry_view_type] = { :value => 'small' }
      redirect_to(:action => 'index',
                  :category => params[:category])
    end
    if params[:category]
      @category_name = params[:category]
    else
      @category_name = 'personal'
    end
    cookies[:hotentry_view_type] = { :value => 'small' }
    @order = 1
    @hash = {}
    if @category_name == 'personal'
      @entries = Article.get_personal_hotentry(get_login_user)
    else
      @entries = Article.get_hotentry_articles(@category_name)
    end
    @entries.each do |e|
      @hash[e.id] = @order
      @order += 1
    end
    @entries = Kaminari.paginate_array(@entries).page(
      params[:page]
    ).per(Article::HOTENTRY_DISPLAY_NUM_SMALL)
  end

  def large
    unless action_name == 'index'
      cookies[:hotentry_view_type] = { :value => 'large' }
      redirect_to(:action => 'index',
                  :category => params[:category])
    end
    if params[:category]
      @category_name = params[:category]
    else
      @category_name = 'personal'
    end
    cookies[:hotentry_view_type] = { :value => 'large' }
    if @category_name == 'personal'
      @entries = Article.get_personal_hotentry(get_login_user)
    else
      @entries = Article.get_hotentry_articles(@category_name)
    end
    @entries = Kaminari.paginate_array(@entries).page(
      params[:page]
    ).per(Article::HOTENTRY_DISPLAY_NUM_LARGE)
  end
end
