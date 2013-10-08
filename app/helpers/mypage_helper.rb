module MypageHelper
  def render_page_ejection(page, table, param, total_num)
      return render :partial => "page_ejection", 
                    :locals => {:page => page, :table_size => table.size, 
                      :page_param => param, :total_num => total_num}
  end

  def get_page_position(page, table, total_num)
    page_position = ""

    if total_num > 0
      page_position = ((page.to_i - 1)*10 + 1).to_s + "-" + 
                      ((page.to_i - 1) * 10 + table.size).to_s + 
                      "<span> of </span>" + total_num.to_s 
    else
      page_position = "0 <span> of </span> 0"
    end
    return page_position
  end

  def is_selected_sort_type(title, type, id)
    if title == type
      return '<span id="' + id + '" ' + 'class="glyphicon glyphicon-ok"></span><span>' + type + '</span>'
    else
      return '<span id="' + id + '""></span><span>' + type + '</span>'
    end
  end

  def render_article_table(tab, table, page)
    if table
      return render :partial => "article_table", 
                    :locals => {:click_checkbox => "clickArticleCheckBox(#{tab}_checkbox, '#{tab}', '#{page}')"}, 
                    :object => table
    end
  end

  def render_summary_table(tab, table, page)
    if table
      render :partial => "summary_table", 
              :locals => {:click_checkbox => "clickArticleCheckBox(#{tab}_checkbox, '#{tab}', '#{page}')"}, 
              :object => table
    end
  end
end
