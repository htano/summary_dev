class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :signed_in?, :get_current_user_name, :get_login_user, :getNotifyingObjects

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

  def isLoginUser?(user_name)
    @result = false
    if get_login_user
      if get_login_user.name == user_name
        @result = true
      end
    end
    return @result
  end

  def get_login_user
    #if not login, return 'nil'
    @user_obj = User.get_user_by_openid(session[:openid_url])
    if @user_obj
      return @user_obj
    else
      @remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
      @user_obj_by_token = User.get_user_by_login_token(cookies[:keep_login_token], @remote_ip)
      if @user_obj_by_token
        return @user_obj_by_token
      else
        cookies.delete :keep_login_token
        return nil
      end
    end
  end

  def getNotifyingObjects
    return get_login_user.get_notifying_articles
  end

  private
  def exec_authenticate
    if Rails.env.production?
      authenticate
    end
  end

  def authenticate
    authenticate_or_request_with_http_basic('Enter Password') do |u, p|
      u == 'summary.dev' && Digest::MD5.hexdigest(p) == "7fd9244849e93ace721ae1c569a939aa"
    end
  end

  before_filter :exec_authenticate
end
