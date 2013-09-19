module MypageHelper
  def render_page_ejection(page, table, param, total_num)
      render :partial => "page_ejection", :locals => {:page => page, :table_size => table.size, :page_param => param, :total_num => total_num}
  end

  def get_page_position(page, table, total_num)
    if total_num > 0
      ((page.to_i - 1)*10 + 1).to_s + "-" + ((page.to_i - 1) * 10 + table.size).to_s + "<span> of </span>" + total_num.to_s 
    else
      "0 <span> of </span> 0"
    end
  end

  def render_article_table(tab, table)
    if table
      render :partial => "article_table", :locals => {:click_checkbox => "clickArticleCheckBox(#{tab}_checkbox, '#{tab}')"}, :object => table
    end
  end

  def render_summary_table(tab, table)
    if table
      render :partial => "summary_table", :locals => {:click_checkbox => "clickArticleCheckBox(#{tab}_checkbox, '#{tab}')"}, :object => table
    end
  end
end
