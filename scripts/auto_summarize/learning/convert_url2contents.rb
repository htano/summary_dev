# encoding: utf-8
require 'open-uri'
require 'extractcontent'

doc = nil
@url = ENV["URL"]
body = ""
title = ""
open(@url) do |io|
  html = io.read
  begin
    html = html.force_encoding("UTF-8")
    html = html.encode("UTF-8", "UTF-8")
    body, title = ExtractContent.analyse(html)
  rescue => e
  end
end

puts title
puts body.gsub(/\n/, "")
