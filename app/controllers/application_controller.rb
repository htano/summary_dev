class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :signed_in?, :get_current_user_name, :getLoginUser, :getNotifyingObjects

  def get_current_user_name
    if getLoginUser
      return getLoginUser.name
    else
      return nil
    end
  end

  def signed_in?
    return (getLoginUser != nil)
  end

  def isLoginUser?(user_name)
    @result = false
    if getLoginUser
      if getLoginUser.name == user_name
        @result = true
      end
    end
    return @result
  end

  def getLoginUser
    #if not login, return 'nil'
    return User.getUserObj(session[:openid_url])
  end

  def getNotifyingObjects
    return getLoginUser.getNotifyingArticles
  end

end
