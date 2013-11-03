# encoding: utf-8
require 'open-uri'
require './lib/contents-extractor.rb'

url = ENV["URL"]

begin
  html = open(url) do |f|
    f.read
  end
rescue => e
  p e
  exit 1
end

# TODO: Singleton使う
factory = ContentsExtractor::ExtractorFactory.new
extractor = factory.new_extractor(url)
extractor.analyze!(html)
puts extractor.get_title
puts extractor.get_body_text
