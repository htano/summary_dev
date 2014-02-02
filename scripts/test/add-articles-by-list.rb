# coding: utf-8
require 'webpage'
include Webpage
ADD_PAGE_NUM = 40
URL_SCORE = "#{Rails.root}/tmp/url_score_uniq.txt"
max_score = 0.01
open(URL_SCORE) do |file|
  file.each_with_index do |line, idx|
    if idx >= ADD_PAGE_NUM
      break
    end
    line.chomp!
    url, score = line.split("\s")
    score = score.to_f
    max_score = score if(score > max_score)
    next if Article.find_by_url(url)
    article = add_webpage(url)
    if article
      article.strength += (score / max_score) * 0.3
      Rails.logger.info("add #{article.strength}, #{article.title}")
      article.save
    end
  end
end
