# coding: utf-8
require './lib/article_classifier.rb'

TITLE_WITH_CLASS="tmp/article_classifier/learning/title_with_class.txt"
MODEL_DIR = Rails.root.to_s + "/lib/article_classifier/model"
DF_FILE = MODEL_DIR + "/df.txt"
DOCUMENT_SIZE = 10000
GRAM_SIZE = 2

df = Hash.new(1)
df.read_kv(DF_FILE)

def idf(ngram, df)
  if df[ngram]
    if df[ngram] > 200
      return 0.0
    else
      return Math.log(DOCUMENT_SIZE / df[ngram])
    end
  else 
    return Math.log(DOCUMENT_SIZE)
  end
end

open(TITLE_WITH_CLASS) do |file|
  file.each do |line|
    line.chomp!
    class_name, title = line.split("\t")
    ngram_array = NgramsParser::ngram(title, GRAM_SIZE)
    tfidf_hash = Hash.new(0)
    ngram_array.each do |ngram|
      tfidf_hash[ngram] += idf(ngram, df)
    end
    print(title)
    tfidf_hash.each do |ng,tfidf|
      if tfidf > 0.0
        print("\t", ng, "\t", tfidf)
      end
    end
    print("\n")
  end
end
