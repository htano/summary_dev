# encoding: utf-8
require "nokogiri"
require "openssl"
require "open-uri"
require "kconv"
require "uri"
require "bundler/setup"
require 'my_delayed_jobs'
require './lib/contents-extractor.rb'

module Webpage
  include MyDelayedJobs
  include ContentsExtractor
  BLANK = ""
  PREVIEW_LENGTH = 100

  def add_webpage(url, tag_list = [])
    article = Article.find_by_url(url)
    if article == nil
      h = get_webpage_element(url)
      return nil if h == nil
      article = Article.create(
        :url => url,
        :title => h["title"],
        :contents_preview => h["contentsPreview"][0, PREVIEW_LENGTH],
        :category_id => 0,
        :cluster_id => 0,
        :thumbnail => h["thumbnail"],
      )
      if article
        summarize_job = SummarizingJob.new(article.id)
        summarize_job.delay.run
        thumbnail_job = ThumbnailingJob.new(article.id)
        thumbnail_job.delay.run
        classify_job = ClassifyingJob.new(article.id)
        classify_job.delay.run
        cluster_job = ClusteringJob.new(article.id)
        cluster_job.delay.run
      end
    end
    article.add_strength
    begin
      get_login_user.add_cluster_id(article.cluster_id)
      user_article = UserArticle.edit_user_article(
        get_login_user.id, article.id
      )
      UserArticleTag.edit_user_article_tag(
        user_article.id, 
        tag_list
      )
    rescue => err_u
      Rails.logger.error("Error: #{err_u}")
    end
    return article
  end

  def remove_webpage(article_id)
    user_article = get_login_user.user_articles.find_by_article_id(article_id)
    if user_article
      article = Article.find(article_id)
      article.remove_strength(get_login_user.id)
      get_login_user.delete_cluster_id(article.cluster_id)
      user_article.destroy
    end
  end

  def get_webpage_element(url, 
                          title_flg = true, 
                          contentsPreview_flg = true, 
                          thumbnail_flg = true)
    ext_fac = ExtractorFactory.instance
    c_ext = ext_fac.new_extractor(url)
    html = c_ext.openurl_wrapper(url)
    unless html
      logger.warn("[get_webpage_element] Can't get html: #{url}")
      return nil
    end
    if c_ext.analyze!(html)
      title = title_flg ? c_ext.get_title : nil
      contentsPreview = 
        contentsPreview_flg ? c_ext.get_body_text : nil
    end
    if title == nil || title == BLANK
      title = URI.parse(url).host
    end
    unless contentsPreview
      contentsPreview = ""
    end
    thumbnail = nil
    h = {
      "title" => title, 
      "thumbnail" => thumbnail,
      "contentsPreview" => contentsPreview
    }
    return h
  end
end
