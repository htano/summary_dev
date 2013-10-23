# coding: utf-8
require './lib/article_classifier.rb'

MODEL_DIR = Rails.root.to_s + "/lib/article_classifier/model"
DF_FILE = MODEL_DIR + "/df.txt"
DOCUMENT_SIZE = 10000
GRAM_SIZE = 2
MAX_TERM_NUM = 20
CLUSTER_FILE = Rails.root.to_s + "/tmp/personal-hotentry/tmp/bayon-cluster.txt"

def idf(ngram, df)
  if df[ngram]
    return Math.log(DOCUMENT_SIZE / df[ngram])
  else 
    return Math.log(DOCUMENT_SIZE)
  end
end

def normalize!(h)
  norm = 0.0
  h.each do |key, value|
    norm += value * value
  end
  norm = Math.sqrt(norm)
  h.each do |key, value|
    h[key] = value / norm
  end
end

df = Hash.new(1)
df.read_kv(DF_FILE)
cluster = Hash.new()
open(CLUSTER_FILE) do |file|
  file.each do |line|
    line.chomp!
    cluster_id, *scores = line.split("\t")
    #p scores
    cluster[cluster_id] = Hash.new(0)
    0.step(scores.length-1, 2) do |i|
      #puts scores[i] + "\t" + scores[i+1]
      cluster[cluster_id][scores[i]] = scores[i+1].to_f
    end
    normalize!(cluster[cluster_id])
  end
end

Article.find(:all).each do |a|
  ngram_array = NgramsParser::ngram(a.title, GRAM_SIZE)
  tfidf_hash = Hash.new(0)
  ngram_array.each do |ngram|
    tfidf_hash[ngram] += idf(ngram, df) / ngram_array.length
  end
  normalize!(tfidf_hash)
  max_cosine = 0.0
  max_cluster_id = 0
  cluster.each do |cluster_id, cluster_center|
    cosine = 0.0
    i = 0
    tfidf_hash.sort_by{|k,v|
      -v
    }.each do |ng, tfidf|
      if i < MAX_TERM_NUM
        cosine += tfidf * cluster_center[ng]
      end
      i += 1
    end
    if cosine > max_cosine
      max_cluster_id = cluster_id
      max_cosine = cosine
    end
  end
  puts max_cluster_id.to_s + "\t" + a.title
end
