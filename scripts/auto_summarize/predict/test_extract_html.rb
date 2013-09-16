# encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'extractcontent'

@url = ENV["URL"]
#@force_nokogiri = true
@force_nokogiri = false

doc = nil
body  = ""
title = ""

charset = nil
html = open(@url) do |f|
  charset = f.charset
  f.read
end
html = html.force_encoding("UTF-8")
html = html.encode("UTF-8", "UTF-8")
if !@force_nokogiri
  begin
    body, title = ExtractContent.analyse(html)
  rescue
    doc = Nokogiri::HTML.parse(html)
    title = doc.title
    doc.xpath('//p').each do |d|
      body += d.text + "\n"
    end
  end
else
  doc = Nokogiri::HTML.parse(html)
  title = doc.title
  doc.xpath('//p').each do |d|
    body += d.text + "\n"
  end
end

puts @url
puts title
puts body
