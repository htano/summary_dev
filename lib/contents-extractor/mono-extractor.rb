# coding: utf-8
require 'bundler/setup'
require 'extractcontent'
require 'nokogiri'

class ContentsExtractor::MonoExtractor < 
  ContentsExtractor::BaseExtractor
  def analyze!(html)
    @html = encode_utf8(html)
    body_text = ""
    begin
      body_text, @title = ExtractContent.analyse(@html)
      Rails.logger.debug("[ContentsExtractor:ExtractContent] #{@title}")
    rescue
      doc = Nokogiri::HTML.parse(@html)
      @title = doc.title
      Rails.logger.debug("[ContentsExtractor:Nokogiri] #{@title}")
      doc.xpath('//p').each do |d| 
        #d_text = d.text.gsub(/\r?\n/, "")
        body_text += d.text + "\n"
      end 
    end 
    return parse_text(body_text)
  end
end

