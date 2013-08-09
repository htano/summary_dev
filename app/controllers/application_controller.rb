class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :signed_in?, :get_current_user_name

  def get_current_user_name
    return U010User.getName(session[:openid_url])
  end

  def signed_in?
    return U010User.isExists?(session[:openid_url])
  end

end
