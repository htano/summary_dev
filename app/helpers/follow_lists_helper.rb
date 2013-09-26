module FollowListsHelper
  def render_follow_status(user)
    current_user = getLoginUser

    if current_user.favorite_users.exists?(:favorite_user_id => user.id)
      return button_to "unfollow", 
            {:action => "unfollow", :controller => "mypage", :unfollow_user_id => user.id}, 
            {:id => "unfollow-button", :class => "btn btn-danger btn-xs", :remote => true}
    else
      return button_to "follow", 
              {:action => "follow", :controller => "mypage", :follow_user_id => user.id}, 
              {:id => "follow-button", :class => "btn btn-info btn-xs", :remote => true}
    end
  end

  def render_user_information(user)
    register_num = user.user_articles.size
    register_str = ""
    if register_num > 1
      register_str = register_num.to_s + " articles registerd"
    else
      register_str = register_num.to_s + " article registered"
    end

    summary_num = user.summaries.size
    summary_str = ""
    if summary_num > 1
      summary_str = "edited " + summary_num.to_s + " summaries"
    else
      summary_str = "edited " + summary_num.to_s + " summary"
    end

    return content_tag(:p, register_str + ", " + summary_str)
  end
end
