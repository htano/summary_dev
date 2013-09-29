# encoding: utf-8

require "nokogiri"
require "openssl"
require "open-uri"
require "kconv"
require "uri"
require "bundler/setup"
require "extractcontent"
require "RMagick"

class WebpageController < ApplicationController

  #定数定義
  BLANK = ""
  THRESHOLD_ALL = 10000
  THRESHOLD_SIDE = 120

  def add
    if signed_in?
      @user_id = "#{params[:id]}"
      @msg = "#{params[:msg]}"
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end
  
  def add_confirm
    if signed_in?
      @user_id = getLoginUser.id
      @url = "#{params[:url]}"
      h = get_article_element(@url, true, false, false)
      if h == nil
        @msg = "Please check URL."
        redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
      end

      @title = h["title"]
      @recent_tags = UserArticle.get_recent_tag(@user_id)
      #@top_rated_tags = []

      article = Article.find_by_url(@url) 
      unless article == nil
        user_article = article.user_articles.find_by_user_id(@user_id)
        unless user_article == nil
          @msg = "you already registered."
          redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
        end
        @summary_num = article.summaries.count(:all)
        @article_id = article.id
        @top_rated_tags = article.get_top_rated_tag
      end

    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_add_history_for_chrome_extension
    if signed_in?
      user_id = getLoginUser.id
      @url = "#{params[:url]}"
      article = Article.find_by_url(@url)
      if article == nil
        render :text => BLANK and return
      else
        user_article = article.user_articles.find_by_user_id(user_id)
        if user_article == nil
          render :text => BLANK and return
        else
          render :text => article.id and return
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  #TODO 画面からURL直打ちの回避
  def get_current_user_name_for_chrome_extension
    if signed_in?
      render :text => get_current_user_name and return
    else
      render :text => BLANK and return
    end
  end

  #TODO 画面からURL直打ちの回避
  def add_for_chrome_extension
    if signed_in?
      user_id = getLoginUser.id
      @prof_image =  getLoginUser.prof_image
      @url = "#{params[:url]}"
      if title == nil
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => "text/html" and return
      end
      article = Article.find_by_url(@url)
      if article == nil
        h = get_article_element(@url)
        if h == nil
          @msg = "Please check URL."
          redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
        end
        @title = h["title"]
        @contents_preview = h["contentsPreview"]
        @thumbnail = h["thumbnail"]

        article = Article.new(:url => params[:url], :title => title, :contents_preview => @contents_preview[0, 200], :category_id =>"001", :thumbnail => @thumbnail)
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false)
          if user_article.save
            article.add_strength
            render :text => article.id and return
          end
        end
      else
        @contents_preview = article.contents_preview
        @thumbnail = article.thumbnail
        user_article = article.user_articles.find_by_user_id(user_id)
        if user_article == nil
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false)
          if user_article.save
            article.add_strength
            render :text => article.id and return
          end
        else
          render :text => article.id and return
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  def add_complete
    if signed_in?
      user_id = getLoginUser.id
      @prof_image =  getLoginUser.prof_image
      @url = "#{params[:url]}"
      tag_list = []
      params.each do |key,value|
        if key.start_with?("tag_text_")
          tag_list.push(value) unless value == BLANK || tag_list.include?(value)
        end
      end

      article = Article.find_by_url(@url)
      if article == nil
        h = get_article_element(@url)
        if h == nil
          @msg = "Please check URL."
          redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
        end
        @title = h["title"]
        @contents_preview = h["contentsPreview"]
        @thumbnail = h["thumbnail"]
        article = Article.new(:url => params[:url], :title => @title, :contents_preview => @contents_preview[0, 200], :category_id =>"001", :thumbnail => @thumbnail)
        if article.save
          @article_id = article.id
          user_article = UserArticle.new(:user_id => user_id, :article_id => @article_id, :read_flg => false)
          if user_article.save
            UserArticleTag.edit_tag(user_article.id, tag_list)
            @tags = []
            user_article.user_article_tags(:all).each do |user_article_tag|
              @tags.push(user_article_tag.tag)
            end
            article.add_strength
            @msg = "Completed." and return
          end
        end
      else
        @article_id = article.id
        @title = article.title
        @contents_preview = article.contents_preview
        @thumbnail = article.thumbnail
        user_article = article.user_articles.find_by_user_id(user_id)
        if user_article == nil
          user_article = UserArticle.new(:user_id => user_id, :article_id => @article_id, :read_flg => false)
          if user_article.save
            UserArticleTag.edit_tag(user_article.id, tag_list)
            @tags = []
            user_article.user_article_tags(:all).each do |user_article_tag|
              @tags.push(user_article_tag.tag)
            end
            article.add_strength
            @msg = "Completed." and return
          end
        else
          @msg = "you already registered."
          redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  #TODO livedoorのサイトでエラーが発生する。
  def get_article_element(url, title_flg = true, contentsPreview_flg = true, thumbnail_flg = true)
    begin
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        f.read
      end
      title = title_flg ? get_article_title(html) : nil
      contentsPreview = contentsPreview_flg ? get_article_contents_preview(html) : nil
      thumbnail = thumbnail_flg ? get_article_thumbnail(html) : nil
      h = {"title" => title, "thumbnail" => thumbnail, "contentsPreview" => contentsPreview}
      return h
    rescue => e
      logger.error("error :#{e}")
      return nil
    end
  end

  #タイトルを取得するメソッド
  def get_article_title(html)
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      if doc.title == nil || doc.title == BLANK
        return URI.parse("#{params[:url]}").host
      else
        return doc.title
      end
    rescue => e
      logger.error("error :#{e}")
      return BLANK
    end
  end

  #サムネイルを取得するメソッド
  def get_article_thumbnail(html)
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      doc.xpath("//img[starts-with(@src, 'http://')]").each do |img|
        image = Magick::ImageList.new(img["src"])
        columns = image.columns 
        rows = image.rows
        #if columns.to_i > THRESHOLD_SIDE && rows.to_i > THRESHOLD_SIDE && (columns.to_i*rows.to_i) > THRESHOLD_ALL
        if columns.to_i > THRESHOLD_SIDE && rows.to_i > THRESHOLD_SIDE
          return img["src"]
        end
      end
      return "no_image.png"
    rescue => e
        logger.error("error :#{e}")
        return "no_image.png"
    end
  end

  #プレビューを取得するメソッド
  def get_article_contents_preview(html)
    begin
      html = html.force_encoding("UTF-8")
      html = html.encode("UTF-8", "UTF-8")
      contents_preview, title = ExtractContent.analyse(html)
      return contents_preview
    rescue => e
      logger.error("error :#{e}")
      begin
        text = ""
        Nokogiri::HTML.parse(html).xpath("//p").each do |p|
          unless p.inner_text == nil || p.inner_text == BLANK
            text += p.inner_text + "\n"
          end
        end
        return text
      rescue => e
        logger.error("error :#{e}")
        return "プレビューは取得出来ませんでした。"
      end
    end
  end

  def delete
    @aid = params[:article_id]
    user_article = getLoginUser.user_articles.find_by_article_id(@aid)
    if user_article
      Article.find(@aid).remove_strength(getLoginUser.id)
      user_article.destroy
      render :text => "OK"
    else
      render :text => "NG"
    end
  end

  def mark_as_read
    @msg = "NG"
    @aid = params[:article_id]
    @user_article = getLoginUser.user_articles.find_by_article_id(@aid)
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
  end
end