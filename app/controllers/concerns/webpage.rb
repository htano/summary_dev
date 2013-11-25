# encoding: utf-8
require "nokogiri"
require "openssl"
require "open-uri"
require "kconv"
require "uri"
require "bundler/setup"
require "extractcontent"
require "RMagick"
require "image_size"
require 'my_delayed_jobs'

module Webpage
  include MyDelayedJobs
  #TODO 定数定義は外出しにしたい
  BLANK = ""
  THRESHOLD_FILE = 100
  THRESHOLD_IMAGE = 150
  ADVERTISEMENT_LIST = ["amazon","rakuten","bannar","Bannar"]
  EXCEPTION_PAGE_LIST = ["http://g-ec2.images-amazon.com/images/G/09/gno/beacon/BeaconSprite-JP-02._V393500380_.png"]

  def add_webpage(url, tag_list = [])
    article = Article.find_by_url(url)
    if article == nil
      h = get_webpage_element(url)
      return nil if h == nil
      article = Article.create(
        :url => url, 
        :title => h["title"], 
        #:contents_preview => h["contentsPreview"][0, 200],
        :contents_preview => nil,
        :category_id => 0, 
        :cluster_id => 0,
        :thumbnail => h["thumbnail"],
        :html => h["html"]
      )
      if article
        preview_job = PreviewingJob.new(article.id)
        preview_job.delay.run
        thumbnail_job = ThumbnailingJob.new(article.id)
        thumbnail_job.delay.run
        summarize_job = SummarizingJob.new(article.id)
        summarize_job.delay.run
        classify_job = ClassifyingJob.new(article.id)
        classify_job.delay.run
        cluster_job = ClusteringJob.new(article.id)
        cluster_job.delay.run
        fork do
          exec(Rails.root.to_s + "/bin/delayed_job run --exit-on-complete")
        end
      end
    end
    get_login_user.add_cluster_id(article.cluster_id)
    article.add_strength
    user_article = UserArticle.edit_user_article(get_login_user.id, article.id)
    UserArticleTag.edit_user_article_tag(user_article.id, tag_list)
    return article
  end

  def get_webpage_element(url, title_flg = true, contentsPreview_flg = true, thumbnail_flg = true)
    begin
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        f.read
      end
      title = title_flg ? get_webpage_title(url, html) : nil
      #contentsPreview = contentsPreview_flg ? get_webpage_contents_preview(html) : nil
      #thumbnail = thumbnail_flg ? get_webpage_thumbnail(url, html) : nil
      contentsPreview = nil
      thumbnail = nil
      h = {
        "title" => title, 
        "thumbnail" => thumbnail, 
        "contentsPreview" => contentsPreview,
        "html" => html
      }
      return h
    rescue => e
      logger.error("error :#{e}")
      return nil
    end
  end

  #タイトルを取得するメソッド
  def get_webpage_title(url, html)
    doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
    if doc.title == nil || doc.title == BLANK
      return URI.parse(url).host
    else
      return doc.title
    end
  end

  #サムネイルを取得するメソッド
  def get_webpage_thumbnail(url, html)
    img_url = nil
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      doc.xpath("//img").each do |img|
        img_url = img["src"]
        next if img_url == nil or img_url == BLANK
        next if isAdvertisement?(url, img_url)
        next if isExceptionImage?(img_url)
        img_url = URI.join(url, img_url).to_s unless img_url.start_with?("http")
        begin
          file = ImageSize.new(open(img_url, "rb").read)
          unless file.get_width == nil || file.get_height == nil
            if file.get_width > THRESHOLD_FILE && file.get_height > THRESHOLD_FILE
              return img_url
            else
              next
            end
          end
        rescue => e
          logger.info("get_webpage_thumbnail info :#{e}")
          next
        end
        image = Magick::ImageList.new(img_url)
        if image.columns.to_i > THRESHOLD_IMAGE && image.rows.to_i > THRESHOLD_IMAGE
          return img_url
        end
      end
      return "no_image.png"
    rescue => e
        logger.warn("get_webpage_thumbnail info :#{e}")
        return "no_image.png"
    end
  end

  #プレビューを取得するメソッド
  def get_webpage_contents_preview(html)
    begin
      html = html.force_encoding("UTF-8")
      html = html.encode("UTF-8", "UTF-8")
      contents_preview, title = ExtractContent.analyse(html)
      contents_preview.split(BLANK)
      return contents_preview
    rescue => e
      logger.info("get_webpage_contents_preview info :#{e}")
      begin
        contents_preview = BLANK
        Nokogiri::HTML.parse(html).xpath("//p").each do |p|
          unless p.inner_text == nil || p.inner_text == BLANK
            contents_preview += p.inner_text + "\n"
          end
        end
        contents_preview.split(BLANK)
        return contents_preview
      rescue => e
        logger.info("get_webpage_contents_preview info :#{e}")
        return "プレビューは取得出来ませんでした。"
      end
    end
  end

  #広告画像を排除する
  #画像URLにADVERTISEMENT_LISTが含まれる場合は広告と判断する
  #登録しようとしているURLにADVERTISEMENT_LISTが含まれる場合は何もしない
  def isAdvertisement?(url, img_url)
    ADVERTISEMENT_LIST.each do |advertisement|
      if !(url.include?(advertisement)) && img_url.include?(advertisement)
        return true
      end
    end
    return false
  end

  def isExceptionImage?(img_url)
    EXCEPTION_PAGE_LIST.each do |exception_page|
      if img_url == exception_page
        return true
      end
    end
    return false
  end
end
