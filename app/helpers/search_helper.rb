module SearchHelper
  def render_follow_status(user)
    current_user = get_login_user

    if current_user && current_user.favorite_users.exists?(:favorite_user_id => user.id)
      return button_to "unfollow",
            {:action => "unfollow", :controller => "search", :unfollow_user_id => user.id},
            {:id => "unfollow-button", :class => "btn btn-danger btn-xs", :remote => true}
    else
      return button_to "follow",
              {:action => "follow", :controller => "search", :follow_user_id => user.id},
              {:id => "follow-button", :class => "btn btn-info btn-xs", :remote => true}
    end
  end

  def render_read_status(article)
    if article.user_articles.where(:user_id =>get_login_user.id).first
      return button_to "Read cancel",
            {:action => "not_read", :controller => "search", :article_id => article.id},
            {:class => "read_it_cancel", :remote => true}
    else
      return button_to "Read later",
            {:action => "read", :controller => "search", :article_id => article.id},
            {:class => "read_it_later", :remote => true}
    end
  end
end
