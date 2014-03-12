module ApplicationHelper
  def simple_format_2(text)
    return text if text.nil?
    text = h text
    text.gsub(/\r\n|\r|\n/, "<br/>").html_safe
  end

  def render_user_name
    if signed_in?
      return link_to image_tag(get_login_user.prof_image, :size => "23x23", :onerror => 'this.src="'+asset_path('no_image.png')+'"') + 
                      content_tag(:p, get_current_user_name), :controller => "mypage", :action => "index"
    else
    end
  end

end
