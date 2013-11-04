module SearchHelper
  def render_follow_status(user)
    current_user = get_login_user

    if current_user && current_user.favorite_users.exists?(:favorite_user_id => user.id)
      return button_to "unfollow", 
            {:action => "unfollow", :controller => "mypage", :unfollow_user_id => user.id}, 
            {:id => "unfollow-button", :class => "btn btn-danger btn-xs", :remote => true}
    else
      return button_to "follow", 
              {:action => "follow", :controller => "mypage", :follow_user_id => user.id}, 
              {:id => "follow-button", :class => "btn btn-info btn-xs", :remote => true}
    end
  end
end
