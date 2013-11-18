# coding: utf-8
require './lib/article_classifier.rb'
require './lib/contents-extractor.rb'
require "open-uri"
require "extractcontent"

TITLE_WITH_URL = "tmp/personal-hotentry/tmp/title-url.txt"
DOCUMENT_SIZE = 10000
GRAM_SIZE = 2
MAX_TERM_NUM = 10000

factory = ContentsExtractor::ExtractorFactory.instance
open(TITLE_WITH_URL) do |file|
  file.each_with_index do |line, idx|
    line.chomp!
    title, url = line.split("\t")
    contents = title
    begin
      html = open(url) do |f|
        f.read
      end
    rescue => e
      warn("openuri error: #{url}")
      next
    end
    extractor = factory.new_extractor(url)
    extractor.analyze!(html)
    body = extractor.get_body_text
    if body
      contents += " " + body
    end
    contents.gsub!(/\r?\n/, " ")
    ngram_array = NgramsParser::ngram(contents, GRAM_SIZE)
    tfidf_hash = Hash.new(0)
    ngram_array.each do |ngram|
      tfidf_hash[ngram] += 1.0 / ngram_array.length
    end
    print(title)
    i = 0
    tfidf_hash.sort_by{|key, value| 
      -value
    }.each do |ng,tfidf|
      if i < MAX_TERM_NUM
        if tfidf > 0.0
          print("\t", ng, "\t", tfidf)
        end
      end
      i += 1
    end
    print("\n")
    warn(idx.to_s + ": " + title)
  end
end
