module MypageHelper
  def render_profile()
    render :partial => "profile"
  end

  def render_page_ejection(page, table, param, total_num)
    render :partial => "page_ejection", 
           :locals => {:page => page, :table_size => table.size, 
           :page_param => param, :total_num => total_num}
  end

  def get_page_position(page, table, total_num)
    page_position = ""

    if total_num > 0
      page_position = ((page.to_i - 1) * MypageController::TABLE_ROW_NUM + 1).to_s + "-" + 
                      ((page.to_i - 1) * MypageController::TABLE_ROW_NUM + table.size).to_s + 
                      "<span> of </span>" + total_num.to_s 
    else
      page_position = "0 <span> of </span> 0"
    end
    page_position
  end

  def get_sort_title(title)
    t('article_sort.' + get_i18n_sort_type(title))
  end

  def is_selected_sort_type(title, type, id)
    if title == type
      '<span id="' + id + '" ' + 'class="glyphicon glyphicon-ok"></span><span>' + 
        t('article_sort.' + get_i18n_sort_type(type)) + 
        '</span>'
    else
      '<span id="' + id + '""></span><span>' + 
        t('article_sort.' + get_i18n_sort_type(type)) + 
        '</span>'
    end
  end

  def render_article_table(tab, table, page)
    if table
      render :partial => "article_table", 
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

  def get_summary_string(num)
    if num == 1
      t('summary.count_one')
    else
      t('summary.count')
    end
  end

  def get_like_string(num)
    if num == 1
      "like"
    else
      "likes"
    end
  end

  def get_reader_string(num)
    if num == 1
      t('reader.count_one')
    else
      t('reader.count')
    end
  end

  def get_i18n_sort_type(type)
    case type
    when "Oldest"
      "oldest"
    when "Newest"
      "newest"
    when "Least summarized"
      "least_summarized"
    when "Most summarized"
      "most_summarized"
    when "Least read"
      "least_read"
    when "Most read"
      "most_read"
    else
      "oldest"
    end
  end
end
