# coding: utf-8
require 'bundler/setup'
require 'nokogiri'

class ContentsExtractor::XpathExtractor < ContentsExtractor::BaseExtractor
  def analyze!(html)
    html = html.force_encoding("UTF-8")
    html = html.encode("UTF-8", "UTF-8")
    @html = html
    body_text = ""
    doc = Nokogiri::HTML.parse(@html)
    @title = doc.title
    doc.xpath("#{@xpath}").each do |d|
      body_text += d.text + "\n"
    end
    return parse_text(body_text)
  end
end
