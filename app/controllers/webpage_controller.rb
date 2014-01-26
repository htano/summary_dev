require "webpage"
include Webpage

class WebpageController < ApplicationController
  def add_confirm
    if signed_in?
      @user_id = get_login_user.id
      @url = params[:url] == BLANK || params[:url] == nil ? params[:searchtext] : params[:url]
      @add_flag =  params[:add_flag]
      if(/[^ -~｡-ﾟ]/ =~ @url)
        flash[:error] = t("webpage.add_error")
        redirect_to(:back) and return
      end
      @add_flag = params[:add_flag]
      h = get_webpage_element(@url, true, false, false)
      if h == nil || @url.start_with?("chrome://extensions/")
        flash[:error] = t("webpage.add_error")
        redirect_to(:back) and return
      end

      @title = h["title"]
      @recent_tags = UserArticle.get_recent_tag(@user_id)
      @set_tags = []

      article = Article.find_by_url(@url)
      unless article == nil
        @summary_num = article.summaries_count
        @reader_num = article.user_articles_count
        @article_id = article.id
        @top_rated_tags = article.get_top_rated_tag
        user_article = article.user_articles.find_by_user_id(@user_id)
        @set_tags = user_article.get_set_tag unless user_article == nil
      end

    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def add_complete
    if signed_in?
      @prof_image =  get_login_user.prof_image
      @url = params[:url]
      tag_list = []
      params.each do |key,value|
        if key.start_with?("tag_text_")
          tag_list.push(value) unless value == BLANK || tag_list.include?(value)
        end
      end
      article = add_webpage(@url, tag_list)
      if article == nil
        flash[:error] = t("webpage.add_error")
        redirect_to :controller => "mypage", :action => "index" and return
      end
      @add_flag =  params[:add_flag]
      if @add_flag == "true"
        flash[:success] = t("webpage.add_success")
      else
        flash[:success] = t("webpage.tag_edit_success")
      end
      redirect_to :controller => "mypage", :action => "index" and return
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def delete
    if signed_in?
      @aid = params[:article_id]
      user_article = get_login_user.user_articles.find_by_article_id(@aid)
      if user_article
        article = Article.find(@aid)
        article.remove_strength(get_login_user.id)
        get_login_user.delete_cluster_id(article.cluster_id)
        user_article.destroy
        render :text => "OK"
      else
        render :text => "NG"
      end
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def mark_as_read
    if signed_in?
      @msg = "NG"
      @aid = params[:article_id]
      @user_article = get_login_user.user_articles.find_by_article_id(@aid)
      if @user_article
        if @user_article.read_flg
          @user_article.read_flg = false
        else
          @user_article.read_flg = true
        end
        if @user_article.save
          if @user_article.read_flg
            @msg = "mark_as_read"
          else
            @msg = "mark_as_unread"
          end
        end
      end
      render :text => @msg
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end
end
