# coding: utf-8
require 'webpage'
require 'nokogiri'
include Webpage
ADD_PAGE_NUM = 10
URL_SCORE = "#{Rails.root}/tmp/url_score_uniq.txt"
max_score = 0.01
count = 0
open(URL_SCORE) do |file|
  file.each do |line|
    line.chomp!
    url, score = line.split("\s")
    score = score.to_f
    max_score = score if(score > max_score)
    next if url =~ %r{^http://sp\.m\.reuters\.co\.jp/}
    next if url =~ %r{^http://rd\.yahoo\.co\.jp}
    next if Article.find_by_url(url)
    html = nil
    begin
      html = open(url).read
    rescue => err
      Rails.logger.info("[add-articles-by-list] #{err}")
    end
    if html
      begin
        doc = Nokogiri::HTML(html)
        meta_refresh = doc.xpath("//meta[@http-equiv='REFRESH' or @http-equiv='refresh']")
        next if meta_refresh.size > 0
      rescue => err2
        Rails.logger.info("[add-articles-by-list] #{err2}")
        next
      end
    end
    count += 1
    Rails.logger.info("[#{count}] #{url}, #{score}")
    break if count > ADD_PAGE_NUM
    article = add_webpage(url)
    if article
      article.strength += 0.1 + (score / max_score) * 0.05
      Rails.logger.info("add #{article.strength}, #{article.title}")
      article.save
    end
    sleep(1)
  end
end
