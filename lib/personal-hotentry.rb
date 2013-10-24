# coding: utf-8
require 'article_classifier/hash_extended'
require 'singleton'

class PersonalHotentry
  include Singleton

  MODEL_DIR = Rails.root.to_s + "/lib/article_classifier/model"
  DF_FILE = MODEL_DIR + "/df.txt"
  DOCUMENT_SIZE = 10000
  GRAM_SIZE = 2
  MAX_TERM_NUM = 20
  CLUSTER_FILE = Rails.root.to_s + "/lib/personal-hotentry/model/bayon-cluster.txt"

  def initialize
    @df = Hash.new(1)
    @cluster = Hash.new()
    @df.read_kv(DF_FILE)
    read_cluster
  end

  def predict_max_cluster_id(text)
    max_cosine = 0.0
    max_cluster_id = 0
    tfidf_hash = get_tfidf_hash(text)
    @cluster.each do |cluster_id, cluster_center|
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
    return max_cluster_id
  end

  private
  def read_cluster
    open(CLUSTER_FILE) do |file|
      file.each do |line|
        line.chomp!
        cluster_id, *scores = line.split("\t")
        @cluster[cluster_id] = Hash.new(0)
        0.step(scores.length-1, 2) do |i|
          @cluster[cluster_id][scores[i]] = scores[i+1].to_f
        end
        normalize!(@cluster[cluster_id])
      end
    end
  end

  def idf(ngram)
    if @df[ngram]
      return Math.log(DOCUMENT_SIZE / @df[ngram])
    else 
      return Math.log(DOCUMENT_SIZE)
    end
  end

  def get_tfidf_hash(text)
    ngram_array = NgramsParser::ngram(text, GRAM_SIZE)
    tfidf_hash = Hash.new(0)
    ngram_array.each do |ngram|
      tfidf_hash[ngram] += idf(ngram) / ngram_array.length
    end
    normalize!(tfidf_hash)
    return tfidf_hash
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
end
