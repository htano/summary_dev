class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?, :get_current_user_name

  def current_user
    @current_user = U010User.find(:first, :conditions => ["open_id = ?", session[:openid_url]])
    #logger.info("current_user: ")
    #logger.info(@current_user)
    return (@current_user != nil)
  end

  def get_current_user_name
    @current_user_name = U010User.find(:first, :conditions => ["open_id = ?", session[:openid_url]]).user_name
    #logger.info(@current_user_name)
    return @current_user_name
  end

  def signed_in?
    current_user
  end

end
