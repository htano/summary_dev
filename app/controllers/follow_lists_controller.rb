include FollowManager

class FollowListsController < ApplicationController
  DISPLAY_USER_NUM = 20

  before_filter :require_login

  def followers
    @user_name = params[:name] ? params[:name] : get_current_user_name
    user = User.find_by_name(@user_name)

    number = 
      params[:number].to_i > 0 ? params[:number].to_i : 0
    offset = DISPLAY_USER_NUM * number

    follower_ids = 
      FavoriteUser.where(:favorite_user_id => user.id).offset(offset).limit(DISPLAY_USER_NUM).pluck(:user_id)
    @followers = User.where(:id => follower_ids)
  end

  def following
    @user_name = params[:name] ? params[:name] : get_current_user_name
    user = User.find_by_name(@user_name)

    number = 
      params[:number].to_i > 0 ? params[:number].to_i : 0
    offset = DISPLAY_USER_NUM * number

    following_ids = 
      user.favorite_users.offset(offset).limit(DISPLAY_USER_NUM).pluck(:favorite_user_id)
    @following_users = User.where(:id => following_ids)
  end

  def suggestion
    @user_name = get_user_name(params[:name])
    @candidate_users = []

    if signed_in? && User.exists?(:name => params[:name])
      user = User.find_by_name(@user_name)
      current_user = get_login_user

      followers = FavoriteUser.where(:favorite_user_id => user.id)
                              .pluck(:user_id)
      followers.delete(current_user.id.to_i)

      login_user_favorites = current_user.favorite_users.pluck(:favorite_user_id)

      followers = followers - login_user_favorites

      candidates = FavoriteUser.where(:user_id => login_user_favorites, :favorite_user_id => followers)
                               .pluck(:favorite_user_id).uniq

      number = 
        params[:number].to_i > 0 ? params[:number].to_i : 0
      offset = DISPLAY_USER_NUM * number

      @candidate_users = 
        User.where(:id => candidates).offset(offset).take(DISPLAY_USER_NUM)
    end
  end

private
  def require_login
    if params[:name] == nil && signed_in? == false
      redirect_to :controller => 'consumer', :action => 'index'
    end
  end
  private

  def get_user_name(param)
    if param
      user_name = param
    else
      user_name = get_current_user_name
    end
    return user_name
  end
end
