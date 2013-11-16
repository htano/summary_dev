# coding: utf-8
require 'bundler/setup'
require 'extractcontent'
require 'nokogiri'

class ContentsExtractor::MonoExtractor < ContentsExtractor::BaseExtractor
  def analyze!(html)
    html = html.force_encoding("UTF-8")
    html = html.encode("UTF-8", "UTF-8")
    @html = html
    body_text = ""
    begin
      body_text, @title = ExtractContent.analyse(@html)
    rescue
      doc = Nokogiri::HTML.parse(@html)
      @title = doc.title
      doc.xpath('//p').each do |d| 
        body_text += d.text + "\n"
      end 
    end 
    return parse_text(body_text)
  end
end
