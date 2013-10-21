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

module Webpage

  #TODO 定数定義は外出しにしたい
  BLANK = ""
  THRESHOLD_FILE = 100  
  THRESHOLD_IMAGE = 150
  ADVERTISEMENT_LIST = ["amazon","rakuten"]
  EXCEPTION_PAGE_LIST = ["http://g-ec2.images-amazon.com/images/G/09/gno/beacon/BeaconSprite-JP-02._V393500380_.png"]

  def get_webpage_element(url, title_flg = true, contentsPreview_flg = true, thumbnail_flg = true)
    begin
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        f.read
      end
      title = title_flg ? get_webpage_title(url, html) : nil
      contentsPreview = contentsPreview_flg ? get_webpage_contents_preview(html) : nil
      thumbnail = thumbnail_flg ? get_webpage_thumbnail(url, html) : nil
      h = {"title" => title, "thumbnail" => thumbnail, "contentsPreview" => contentsPreview}
      return h
    rescue => e
      logger.error("error :#{e}")
      return nil
    end
  end

  #タイトルを取得するメソッド
  def get_webpage_title(url, html)
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      if doc.title == nil || doc.title == BLANK
        return URI.parse(url).host
      else
        return doc.title
      end
    rescue => e
      logger.error("error :#{e}")
      return BLANK
    end
  end

  #サムネイルを取得するメソッド
  def get_webpage_thumbnail(url, html)
    img_url = nil
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      doc.xpath("//img").each do |img|
        img_url = img["src"]
        next if img_url == nil
        next if isAdvertisement?(url, img_url)
        next if isExceptionPage?(img_url)
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
          logger.error("error :#{e}")
          next
        end
        image = Magick::ImageList.new(img_url)
        if image.columns.to_i > THRESHOLD_IMAGE && image.rows.to_i > THRESHOLD_IMAGE
          return img_url
        end
      end
      return "no_image.png"
    rescue => e
        logger.error("error :#{e}")
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
      logger.error("error :#{e}")
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
        logger.error("error :#{e}")
        return "プレビューは取得出来ませんでした。"
      end
    end
  end

  #広告画像を排除する
  #画像URLにamazon, rakutenが入っている場合は広告と判断する
  #登録しようとしているURLにamazon, rakutenが入っている場合は何もしない
  def isAdvertisement?(url, img_url)
    ADVERTISEMENT_LIST.each do |advertisement|
      if !(url.include?(advertisement)) && img_url.include?(advertisement)
        return true
      end
    end
    return false
  end

  def isExceptionPage?(img_url)
    EXCEPTION_PAGE_LIST.each do |exception_page|
      if img_url == exception_page
        return true
      end
    end
    return false
  end
end
