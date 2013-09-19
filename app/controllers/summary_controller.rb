# encoding: utf-8

class SummaryController < ApplicationController

  def delete
    if signed_in?
      user_id = getLoginUser.id
      @article_id = "#{params[:article_id]}"
      summary = Summary.find_by_user_id_and_article_id(user_id, @article_id)
      if summary != nil
        if summary.destroy
          redirect_to :controller => "mypage", :action => "index"
        end
      else
        redirect_to :controller => "mypage", :action => "index"
      end 
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def edit
    if signed_in?
      @article_id = "#{params[:article_id]}"
      article = Article.find_by id: @article_id
      if article == nil
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html' and return
      end
      @url = article.url
      @title = article.title
      @summary_num = article.summaries.count(:all)
      user_id = getLoginUser.id
      summary = Summary.find_by_user_id_and_article_id(user_id, @article_id)
      if summary != nil
        @content = summary.content
        @content_num = summary.content.gsub(/\r\n|\r|\n/, "").length
      else
        @content = "Please edit summary within 300 characters."
        @content_num = 0
        @firstEditFlag = true
      end
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def edit_complete
    if signed_in?
      user_id = getLoginUser.id
      @article_id = "#{params[:article_id]}"
      article = Article.find_by id: @article_id
      if article == nil
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html' and return
      end
      summary = Summary.find_by_user_id_and_article_id(user_id, @article_id)
      if summary != nil
        #すでに当該記事に対して要約が登録されていた場合、以下の処理をする
        summary.update_attribute(:content, params[:content])
        if summary.save
          redirect_to :controller => "summary_lists", :action => "index", :articleId => @article_id
        end
      else
        #当該記事に対して要約が登録されていなかった場合、以下の処理をする
        summary = Summary.new(:content => params[:content],:user_id => user_id,:article_id => @article_id)
        if summary.save
          redirect_to :controller => "summary_lists", :action => "index", :articleId => @article_id
        end
      end 
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end
end
  