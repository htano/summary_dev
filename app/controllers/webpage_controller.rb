# encoding: utf-8

require 'nokogiri'
require 'openssl'
require 'open-uri'
require 'kconv'
require 'uri'
require 'bundler/setup'
require 'extractcontent'
require 'RMagick'

class WebpageController < ApplicationController

  #定数定義
  BLANK = ""
  THRESHOLD_ALL = 20000
  THRESHOLD_SIDE = 100
  WIDTH  = 80
  HEIGHT = 80

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
      @user_id = "#{params[:id]}"
      @url = "#{params[:url]}"
      h = getArticleElement(@url, true, false, false)
      if h == nil
        @msg = "Please check URL."
        redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
      end

      @title = h["title"]

      article = Article.find_by_url(@url)
 
      if article != nil
        @summary_num = article.summaries.count(:all)
        @article_id = article.id
        #当該記事に設定されているタグの取得
        #TODO 当該記事に設定されているタグの取得条件を修正する必要がある
        @tags = []
        article.user_articles(:all).each do |user_article|
          user_article.user_article_tags(:all).each do |user_article_tag|
            @tags.push(user_article_tag.tag)
          end
        end
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
      if article != nil
        user_article = article.user_articles.find_by_user_id(user_id)
        if user_article != nil 
          #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、article.idを返却する
          render :text => article.id and return
        else
          render :text => BLANK and return
        end
      else
        render :text => BLANK and return
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
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html' and return
      end
      article = Article.find_by_url(@url)
      if article != nil
        @contents_preview = article.contents_preview
        @thumbnail = article.thumbnail
        user_article = article.user_articles.find_by_user_id(user_id)
        if user_article != nil
          render :text => article.id and return
        else
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id,:read_flg => false)
          if user_article.save
            article.addStrength
            render :text => article.id and return
          end
        end
      else

        h = getArticleElement(@url)
        if h == nil
          @msg = "Please check URL."
          redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
        end
        @title = h["title"]
        @contents_preview = h["contentsPreview"]
        @thumbnail = h["thumbnail"]

        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:url], :title => title, :contents_preview => @contents_preview[0, 200], :category_id =>"001", :thumbnail => @thumbnail)
        if article.save
          user_article = UserArticle.new(:user_id => user_id, :article_id => article.id, :read_flg => false)
          if user_article.save
            article.addStrength
            render :text => article.id and return
          end
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
      #TODO このコードはイケてない、明日直す
      tag_list.push(params[:tag_text_1]) if params[:tag_text_1] != BLANK && !tag_list.include?(params[:tag_text_1])
      tag_list.push(params[:tag_text_2]) if params[:tag_text_2] != BLANK && !tag_list.include?(params[:tag_text_2])
      tag_list.push(params[:tag_text_3]) if params[:tag_text_3] != BLANK && !tag_list.include?(params[:tag_text_3])
      tag_list.push(params[:tag_text_4]) if params[:tag_text_4] != BLANK && !tag_list.include?(params[:tag_text_4])
      tag_list.push(params[:tag_text_5]) if params[:tag_text_5] != BLANK && !tag_list.include?(params[:tag_text_5])
      tag_list.push(params[:tag_text_6]) if params[:tag_text_6] != BLANK && !tag_list.include?(params[:tag_text_6])
      tag_list.push(params[:tag_text_7]) if params[:tag_text_7] != BLANK && !tag_list.include?(params[:tag_text_7])
      tag_list.push(params[:tag_text_8]) if params[:tag_text_8] != BLANK && !tag_list.include?(params[:tag_text_8])
      tag_list.push(params[:tag_text_9]) if params[:tag_text_9] != BLANK && !tag_list.include?(params[:tag_text_9])
      tag_list.push(params[:tag_text_10]) if params[:tag_text_10] != BLANK && !tag_list.include?(params[:tag_text_10])


      article = Article.find_by_url(@url)
      if article != nil
        @article_id = article.id
        @title = article.title
        @contents_preview = article.contents_preview
        @thumbnail = article.thumbnail
        user_article = article.user_articles.find_by_user_id(user_id)
        if user_article != nil
          #同じURLの情報は存在するかつ、ユーザーがすでに登録している場合、エラーメッセージを表示する
          UserArticleTag.editTag(user_article.id, tag_list)
          @tags = []
          user_article.user_article_tags(:all).each do |user_article_tag|
            @tags.push(user_article_tag.tag)
          end
          @msg = "Already registered."  and return
        else
          #同じURLの情報は存在するが、ユーザーが登録していない場合、r010のみinsertする
          user_article = UserArticle.new(:user_id => user_id, :article_id => @article_id, :read_flg => false)
          if user_article.save
            UserArticleTag.editTag(user_article.id, tag_list)
            @tags = []
            user_article.user_article_tags(:all).each do |user_article_tag|
              @tags.push(user_article_tag.tag)
            end
            article.addStrength
            @msg = "Completed." and return
          end
        end
      else

        h = getArticleElement(@url)
        if h == nil
          @msg = "Please check URL."
          redirect_to :controller => "webpage", :action => "add", :msg => @msg and return
        end
        @title = h["title"]
        @contents_preview = h["contentsPreview"]
        @thumbnail = h["thumbnail"]
        #同じURLの情報がない場合、a010とr010両方にinsertする
        #カテゴリはペンディング事項
        article = Article.new(:url => params[:url], :title => @title, :contents_preview => @contents_preview[0, 200], :category_id =>"001", :thumbnail => @thumbnail)
        if article.save
          @article_id = article.id
          user_article = UserArticle.new(:user_id => user_id, :article_id => @article_id, :read_flg => false)
          if user_article.save
            UserArticleTag.editTag(user_article.id, tag_list)
            @tags = []
            user_article.user_article_tags(:all).each do |user_article_tag|
              @tags.push(user_article_tag.tag)
            end
            article.addStrength
            @msg = "Completed." and return
          end
        end
      end
    else
      redirect_to :controller => "consumer", :action => "index"
    end
  end

  #TODO livedoorのサイトでエラーが発生する。
  def getArticleElement(url, title_flg = true, contentsPreview_flg = true, thumbnail_flg = true)
    begin
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        f.read
      end
      title = title_flg ? getArticleTitle(html) : nil
      contentsPreview = contentsPreview_flg ? getArticleContentsPreview(html) : nil
      thumbnail = thumbnail_flg ? getArticleThumbnail(html) : nil
      h = {"title" => title, "thumbnail" => thumbnail, "contentsPreview" => contentsPreview}
      return h
    rescue => e
      logger.error("error :#{e}")
      return nil
    end
  end

  #タイトルを取得するメソッド
  def getArticleTitle(html)
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      if doc.title != nil && doc.title != BLANK
        return doc.title
      else
        #タイトルが取得出来ない時はホスト名をタイトルに設定する
        return URI.parse("#{params[:url]}").host
      end
    rescue => e
      logger.error("error :#{e}")
      return BLANK
    end
  end

  #サムネイルを取得するメソッド
  def getArticleThumbnail(html)
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      doc.xpath("//img[starts-with(@src, 'http://')]").each do |img|
        image = Magick::ImageList.new(img['src'])
        columns = image.columns 
        rows = image.rows
        #閾値を超える最初の画像を象徴的な画像として返却する
        if columns.to_i > THRESHOLD_SIDE and rows.to_i > THRESHOLD_SIDE and (columns.to_i*rows.to_i) > THRESHOLD_ALL
          return img['src']
        end
      end
      return "no_image.png"
    rescue => e
        logger.error("error :#{e}")
        return "no_image.png"
    end
  end

  #プレビューを取得するメソッド
  def getArticleContentsPreview(html)
    begin
      html = html.force_encoding("UTF-8")
      html = html.encode("UTF-8", "UTF-8")
      contents_preview, title = ExtractContent.analyse(html)
      return contents_preview
       # logger.debug("content_preview : #{contents_preview}")
    rescue => e
      logger.error("error :#{e}")
      begin
      	text = ""
        Nokogiri::HTML.parse(html).xpath('//p').each do |p|
          if p.inner_text != nil and p.inner_text != BLANK
            text += p.inner_text + "\n"
           end
        end
        return text
        # logger.debug("content_preview : #{contents_preview}")
      rescue => e
        logger.error("error :#{e}")
        return "プレビューは取得出来ませんでした。"
      end
    end
  end

  #プレビューを取得するメソッド(Nokogiriのみ)
  def getArticleContentsPreview_N(html)
    begin
      contents_preview = ""
      Nokogiri::HTML.parse(html).xpath('//p').each do |p|
        if p.text?
          contents_preview += p.text
        end
        p.children.each do |child|
          contents_preview += child.text
        end
      end
      return contents_preview
        # logger.debug("content_preview : #{contents_preview}")
    rescue => e
      # TODO : enable to handle "ArgumentError - invalid byte sequence in UTF-8:"
      logger.error("error :#{e}")
      return "本文が取得出来ませんでした。"
    end
  end
end
