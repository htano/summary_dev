class FollowListsController < ApplicationController
  DISPLAY_USER_NUM = 20

  def followers
    @user_name = get_user_name(params[:name])
    user = User.find_by_name(@user_name)

    number = 0
    if params[:number]
      number = params[:number].to_i
    end
    logger.debug("number : #{number}")
    offset = DISPLAY_USER_NUM * number

    follower_users = FavoriteUser.where(:favorite_user_id => user.id).offset(offset).take(DISPLAY_USER_NUM)
    @followers = []
    follower_users.each do |follower_user|
      follower = follower_user.user
      if follower != getLoginUser
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
    logger.debug("number : #{number}")
    offset = DISPLAY_USER_NUM * number

    @following_users = []
    user.favorite_users.offset(offset).take(DISPLAY_USER_NUM).each do |favorite_user|
      following_user = User.find(favorite_user.favorite_user_id)
      if following_user != getLoginUser
        @following_users.push(following_user)
      end
    end
  end

  def suggestion
    # FIXME
    @user_name = get_user_name(params[:name])
    user = User.find_by_name(@user_name)
    current_user = getLoginUser

    @candidate_users = []
    user.favorite_users.each do |favorite_user|
      User.find(favorite_user.favorite_user_id).favorite_users.each do |candidate|
        candidate_user = User.find(candidate.favorite_user_id)
        if current_user.favorite_users.exists?(:favorite_user_id => candidate_user.id) == nil ||
            current_user != getLoginUser
          @candidate_users.push(candidate_user)
        end
      end
    end
    @candidate_users = @candidate_users.uniq

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
