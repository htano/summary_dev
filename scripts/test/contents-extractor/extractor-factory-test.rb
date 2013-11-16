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
  p $!
  exit 1
end

factory = ContentsExtractor::ExtractorFactory.instance
extractor = factory.new_extractor(url)
extractor.analyze!(html)
puts "[URL]" + url
puts "[title]" + extractor.get_title
puts "[Body]"
puts extractor.get_body_text
