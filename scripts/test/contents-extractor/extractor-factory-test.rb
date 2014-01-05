# encoding: utf-8
require 'open-uri'
require './lib/contents-extractor.rb'

url = ENV["URL"]

#begin
#  #html = open(url, "r:binary") do |f|
#  #  f.read.encode("utf-8", "euc-jp", :invalid => :replace, :undef => :replace)
#  #html = open(url, "r:binary") do |f|
#  #  f.read.encode("utf-8", f.charset, :invalid => :replace, :undef => :replace)
#  html = open(url) do |f|
#    f.read
#  end
#rescue => e
#  warn "openuri: error was happened."
#  p e
#  exit 1
#end

factory = ContentsExtractor::ExtractorFactory.instance
extractor = factory.new_extractor(url)
html = extractor.openurl_wrapper(url)
unless html
  warn "openuri: error was happened."
  exit 1
end
extractor.analyze!(html)
puts "[URL]" + url
if extractor.get_title
  puts "[title]" + extractor.get_title
end
puts "[Body]"
puts extractor.get_body_text
