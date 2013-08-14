# encoding: utf-8

class SummaryController < ApplicationController
  def edit
    article = Article.find(params[:article_id]);
    @url = article.url;
    @title = article.title;
    user_id = getLoginUser.id;
    summary = Summary.find_by_user_id_and_article_id(user_id, params[:article_id]);
    if summary != nil then
      #すでに当該記事に対して要約が登録されていた場合、以下の処理をする
      @summary_content = summary.content;
    end
  end

  def edit_confirm
    article = Article.find(params[:article_id]);
    @url = article.url;
    @title = article.title;
    user_id = getLoginUser.id;
    @summary_content = "#{params[:summary_content]}";
  end


  def edit_complete
    if signed_in?
      user_id = getLoginUser.id;
      summary = Summary.find_by_user_id_and_article_id(user_id, params[:article_id]);
      if summary != nil then
        #すでに当該記事に対して要約が登録されていた場合、以下の処理をする
        summary.update_attribute(:content, params[:summary_content]);
        if summary.save
          redirect_to :action => "show";
        end
      else
        #当該記事に対して要約が登録されていなかった場合、以下の処理をする
        summary = Summary.new(:content => params[:summary_content],:user_id => user_id,:article_id => params[:article_id]);
        if summary.save
          redirect_to :action => "show";
        end
      end 
    else
    end
  end

  def show
    article = Article.find(params[:article_id]);
    @url = article.url;
    @title = article.title;
    user_id = getLoginUser.id;
    @article_id = "#{params[:article_id]}";
    summary = Summary.find_by_user_id_and_article_id(user_id, @article_id);
    @summary = summary.content;
    @msg = "要約が登録出来ました！"
  end
end
  