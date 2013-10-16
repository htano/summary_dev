# encoding: utf-8
require 'open-uri'
require 'extractcontent'
require "nokogiri"

doc = nil
@url = "http://b.hatena.ne.jp/entrylist/social?of=0"
open(@url) do |io|
  html = io.read
  begin
    html = html.force_encoding("UTF-8")
    html = html.encode("UTF-8", "UTF-8")
    doc = Nokogiri::HTML.parse(html)
  rescue => e
  end
end

doc.xpath('//h3[@class="hb-entry-link-container"]/a').each do |a|
  puts a.attribute("title").value
end
