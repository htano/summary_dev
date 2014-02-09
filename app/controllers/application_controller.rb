class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  if Rails.env.production?
    rescue_from Exception do
      render :template => "errors/error_500", :status => 500, :layout => 'application'
    end
  end

  protect_from_forgery with: :exception
  helper_method :signed_in?, :get_current_user_name, :get_login_user, :get_notifying_objects

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    render :template => "errors/error_404", :status => 404, :layout => 'application', :content_type => 'text/html'
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    render :template => "errors/error_500", :status => 500, :layout => 'application'
  end

  def get_current_user_name
    if get_login_user
      return get_login_user.name
    else
      return nil
    end
  end

  def signed_in?
    return (get_login_user != nil)
  end

  def login_user?(user_name)
    @result = false
    if get_login_user
      if get_login_user.name == user_name
        @result = true
      end
    end
    return @result
  end

  #if not login, return 'nil'
  def get_login_user
    @return_obj = nil
    @user_obj = User.get_user_by_openid(session[:openid_url])
    @user_obj_by_token = nil
    if @user_obj
      @return_obj = @user_obj
    else
      @remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
      if cookies[:keep_login_token]
        @user_obj_by_token = User.get_user_by_login_token(
          cookies[:keep_login_token], 
          @remote_ip
        )
        if @user_obj_by_token
          @return_obj = @user_obj_by_token
        end
      end
    end
    return @return_obj
  end

  def get_notifying_objects
    return get_login_user.get_notifying_articles
  end

  private
  def exec_authenticate
    if Rails.env.production?
      #authenticate
    end
  end

  private
  def set_signed_in_status
    cookies[:signed_in_status] = { :value => signed_in? }
  end

  def authenticate
    authenticate_or_request_with_http_basic('Enter Password') do |u, p|
      u == 'summary.dev' && Digest::MD5.hexdigest(p) == "7fd9244849e93ace721ae1c569a939aa"
    end
  end

  before_filter :exec_authenticate
  after_filter :set_signed_in_status
end
