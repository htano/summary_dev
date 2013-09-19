# encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'extractcontent'
require 'kconv'

@url = ENV["URL"]
#@force_nokogiri = true
@force_nokogiri = false

doc = nil
body  = ""
title = ""

begin
  charset = nil
  html = open(@url) do |f|
    charset = f.charset
    f.read
  end
  html = html.force_encoding("UTF-8")
  html = html.encode("UTF-8", "UTF-8")
rescue => e
  p e
  Rails.logger.error "[ERROR] openuri url=" + @url + ", msg=" + e.message
  puts "[ERROR] openuri url=" + @url + ", msg=" + e.message
  exit 1
end

if !@force_nokogiri
  begin
    body, title = ExtractContent.analyse(html)
  rescue
    puts "Error at ExtractContent."
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

begin
  title.split("")
  body.split("")
rescue => e
  puts $!
  puts e.to_yaml
  p e
  exit 1
end

puts @url
puts title
body.split("\n").each do |p|
  if p.length > 0
    puts p
  end
end
puts "description"
Nokogiri::HTML.parse(html).xpath('//meta[@name="description"]').each do |d| puts d.attribute("content").value + "\n"; end
puts "og:description"
Nokogiri::HTML.parse(html).xpath('//meta[@property="og:description"]').each do |d| puts d.attribute("content").value + "\n"; end
puts "h1"
Nokogiri::HTML.parse(html).xpath('//h1').each do |d| puts d.text + "\n"; end
puts "h2"
Nokogiri::HTML.parse(html).xpath('//h2').each do |d| puts d.text + "\n"; end
puts "h3"
Nokogiri::HTML.parse(html).xpath('//h3').each do |d| puts d.text + "\n"; end
puts "h4"
Nokogiri::HTML.parse(html).xpath('//h4').each do |d| puts d.text + "\n"; end
puts "h5"
Nokogiri::HTML.parse(html).xpath('//h5').each do |d| puts d.text + "\n"; end
puts "h6"
Nokogiri::HTML.parse(html).xpath('//h6').each do |d| puts d.text + "\n"; end
