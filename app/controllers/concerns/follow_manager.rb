module FollowManager
  def get_favorite_users(user)
    favorite_user_ids = user.favorite_users.select(:favorite_user_id)
    return User.where(:id => favorite_user_ids)
  end

  def get_followers(user)
    follower_ids = FavoriteUser.where(:favorite_user_id => user.id).select(:user_id)
    return User.where(:id => follower_ids)
  end
end