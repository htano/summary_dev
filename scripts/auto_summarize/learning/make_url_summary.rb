# encoding: utf-8
require 'open-uri'
require 'extractcontent'
require "nokogiri"

doc = nil
@url = ENV["URL"]
contents_preview = ""
title = ""
open(@url) do |io|
  html = io.read
  begin
    html = html.force_encoding("UTF-8")
    html = html.encode("UTF-8", "UTF-8")
    contents_preview, title = ExtractContent.analyse(html)
    doc = Nokogiri::HTML.parse(html)
  rescue => e
  end
end

# //*[@id="detailHeadline"]/h3/a
puts doc.xpath('//*[@id="detailHeadline"]/h3/a').attribute("href").value
puts contents_preview.gsub(/\n/, "").gsub(/\[記事全文\].*/, "")
