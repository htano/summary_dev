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
    user = User.find_by_name(@user_name)
    current_user = get_login_user

    favorite_user_ids = []
    user.favorite_users.each do |favorite_user|
      id = favorite_user.favorite_user_id
      favorite_user_ids.push(id)
    end

    favorite_users = User.find(favorite_user_ids)
    candidate_user_ids = []
    favorite_users.each do |favorite_user|
      favorite_user.favorite_users.each do |candidate|
        id = candidate.favorite_user_id
        if current_user && 
          current_user.favorite_users.exists?(:favorite_user_id => id) == nil &&
          current_user.id != id
          candidate_user_ids.push(id)
        end
      end
    end
    candidate_user_ids = candidate_user_ids.uniq

    number = 0
    if params[:number]
      number = params[:number].to_i
    end
    offset = DISPLAY_USER_NUM * number

    @candidate_users = 
      User.where(:id => candidate_user_ids).offset(offset).take(DISPLAY_USER_NUM)
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
