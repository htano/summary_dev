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
  THRESHOLD_SIDE = 100  
  ADVERTISEMENTLIST = ["amazon","rakuten"]

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
    img_src = nil
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      doc.xpath("//img").each do |img|
        img_src = img["src"]
        next if img_src == nil
        #next if isAdvertisement?(img_src)
        unless img_src.start_with?("http")
          img_src = URI.join(url, img_src).to_s
        end
        p img_src
        begin
          open(img_src, "rb"){|f|
            file = ImageSize.new(f.read)
            unless file.get_width == nil || file.get_height == nil
              if file.get_width > THRESHOLD_SIDE && file.get_height > THRESHOLD_SIDE
                return img_src
              end
            end
          }
        rescue => e
          logger.error("error :#{e}")
          next
        end
        image = Magick::ImageList.new(img_src)
        columns = image.columns 
        rows = image.rows
        if columns.to_i > THRESHOLD_SIDE && rows.to_i > THRESHOLD_SIDE
          return img_src
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

  def isAdvertisement?(url)
    ADVERTISEMENTLIST.each{|advertisement|
      p url.include?(advertisement) 
      if url.include?(advertisement)
        return true
      end
    }
  end
end
