module SearchHelper
  def render_read_status(article)
    if article.user_articles.where(:user_id =>get_login_user.id).first
      return button_to t("read_later.cancel"),
            {:action => "not_read", :controller => "search", :article_id => article.id},
            {:class => "read_it_cancel", :remote => true}
    else
      return button_to t("read_later.add"),
            {:action => "read", :controller => "search", :article_id => article.id},
            {:class => "read_it_later", :remote => true}
    end
  end
end
