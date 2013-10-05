# encoding: utf-8

require "nokogiri"
require "openssl"
require "open-uri"
require "kconv"
require "uri"
require "bundler/setup"
require "extractcontent"
require "RMagick"

module Webpage

  #定数定義
  BLANK = ""
  THRESHOLD_ALL = 10000
  THRESHOLD_SIDE = 120

  #TODO livedoorのサイトでエラーが発生する。
  def get_webpage_element(url, title_flg = true, contentsPreview_flg = true, thumbnail_flg = true)
    begin
      html = open(url,"r",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
        f.read
      end
      title = title_flg ? get_webpage_title(html) : nil
      contentsPreview = contentsPreview_flg ? get_webpage_contents_preview(html) : nil
      thumbnail = thumbnail_flg ? get_webpage_thumbnail(html) : nil
      h = {"title" => title, "thumbnail" => thumbnail, "contentsPreview" => contentsPreview}
      return h
    rescue => e
      logger.error("error :#{e}")
      return nil
    end
  end

  #タイトルを取得するメソッド
  def get_webpage_title(html)
    begin
      doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
      if doc.title == nil || doc.title == BLANK
        return URI.parse("#{params[:url]}").host
      else
        p doc.title
        return doc.title
      end
    rescue => e
      logger.error("error :#{e}")
      return BLANK
    end
  end

  #サムネイルを取得するメソッド
  def get_webpage_thumbnail(html)
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
end
