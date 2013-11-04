# coding: utf-8
require './lib/article_classifier.rb'
require "open-uri"
require "extractcontent"

TITLE_WITH_URL = "tmp/personal-hotentry/tmp/title-url.txt"
MODEL_DIR = Rails.root.to_s + "/lib/article_classifier/model"
DF_FILE = MODEL_DIR + "/df.txt"
DOCUMENT_SIZE = 10000
GRAM_SIZE = 2
MAX_TERM_NUM = 10000

df = Hash.new(1)
df.read_kv(DF_FILE)

def idf(ngram, df)
  return 1.0
  #if df[ngram]
  #  return Math.log(DOCUMENT_SIZE / df[ngram])
  #else 
  #  return Math.log(DOCUMENT_SIZE)
  #end
end

open(TITLE_WITH_URL) do |file|
  file.each_with_index do |line, idx|
    line.chomp!
    title, url = line.split("\t")
    contents = title
    begin
      html = open(url) do |f|
        f.read
      end
      body, ex_title = ExtractContent.analyse(html)
      body.gsub!(/\r?\n/, " ")
      contents += " " + body
    rescue => e
    end
    contents = contents.force_encoding("UTF-8")
    contents = contents.encode("UTF-8", "UTF-8")
    ngram_array = NgramsParser::ngram(contents, GRAM_SIZE)
    tfidf_hash = Hash.new(0)
    ngram_array.each do |ngram|
      tfidf_hash[ngram] += idf(ngram, df) / ngram_array.length
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
