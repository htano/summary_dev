# encoding: utf-8
require 'open-uri'
Article.all.each do |e|
  uri = URI(e.url)
  domain = uri.host
  puts domain
end
