class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :signed_in?, :get_current_user_name

  def get_current_user_name
    return User.getName(session[:openid_url])
  end

  def signed_in?
    return User.isExists?(session[:openid_url])
  end

  def isLoginUser?(url_user)
    @result = false
    if signed_in?
      @login_user = User.getName(session[:openid_url])
      if @login_user == url_user
        @result = true
      end
    end
    return @result
  end

end
