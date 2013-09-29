# encoding: utf-8
require 'open-uri'
require 'extractcontent'
require "nokogiri"

doc = nil
@url = "http://dailynews.yahoo.co.jp/fc/"
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

# //*[@id="catList"]/div/div/ul/li
doc.xpath('//*[@id="catList"]/div/div/ul/li/a').each do |a|
  puts "http://dailynews.yahoo.co.jp" + a.attribute("href").value
end
