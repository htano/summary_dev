include FollowManager

class FollowListsController < ApplicationController
  DISPLAY_USER_NUM = 20

  def followers
    @user_name = get_user_name(params[:name])
    user = User.find_by_name(@user_name)

    number = 0
    if params[:number]
      number = params[:number].to_i
    end
    offset = DISPLAY_USER_NUM * number

    follower_users = 
      FavoriteUser.where(:favorite_user_id => user.id).offset(offset).take(DISPLAY_USER_NUM)
    @followers = []
    follower_users.each do |follower_user|
      follower = follower_user.user
      if follower != get_login_user
        @followers.push(follower)
      end
    end
  end

  def following
    @user_name = get_user_name(params[:name])
    user = User.find_by_name(@user_name)

    number = 0
    if params[:number]
      number = params[:number].to_i
    end
    offset = DISPLAY_USER_NUM * number

    @following_users = []
    user.favorite_users.offset(offset).take(DISPLAY_USER_NUM).each do |favorite_user|
      following_user = User.find(favorite_user.favorite_user_id)
      if following_user != get_login_user
        @following_users.push(following_user)
      end
    end
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

      number = params[:number] ? params[:number].to_i : 0
      offset = DISPLAY_USER_NUM * number

      @candidate_users = 
        User.where(:id => candidates).offset(offset).take(DISPLAY_USER_NUM)
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
