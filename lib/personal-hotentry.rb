# coding: utf-8
require './lib/text-analyzer.rb'
include TextAnalyzer

class PersonalHotentry
  MAX_TERM_NUM = 100
  CLUSTER_FILE = Rails.root.to_s + 
    "/lib/personal-hotentry/model/bayon-cluster.txt"
  CLUSTER_SCORE_THRESHOLD = 0.08
  TITLE_DF_FILE = Rails.root.to_s + 
    "/lib/text-analyzer/df_dict/title-df.txt"
  BODY_DF_FILE = Rails.root.to_s + 
    "/lib/text-analyzer/df_dict/body-df.txt"

  def initialize
    @df = DocumentFrequency.new(BODY_DF_FILE)
    @df.open_file
    @cluster = Hash.new()
    read_cluster
  end

  def predict_max_cluster_id(text)
    max_cosine = CLUSTER_SCORE_THRESHOLD
    max_cluster_id = 0
    text.gsub!(/\r?\n/, " ")
    tfidf_hash = @df.tfidf(text)
    tfidf_hash = reduce_features(tfidf_hash)
    tfidf_hash = normalize(tfidf_hash)
    @cluster.each do |cluster_id, cluster_center|
      cosine = 0.0
      tfidf_hash.each do |ng, tfidf|
        cosine += tfidf * cluster_center[ng]
      end
      if cosine > max_cosine
        max_cluster_id = cluster_id
        max_cosine = cosine
      end
    end
    return max_cluster_id, max_cosine
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
        @cluster[cluster_id] = normalize(@cluster[cluster_id])
      end
    end
  end

  def reduce_features(h)
    new_h = Hash.new
    h.sort_by{|k,v| -v}.first(MAX_TERM_NUM).each do |k,v|
      new_h[k] = v
    end
    return new_h
  end

  def normalize(h)
    norm = 0.0
    h.each do |key, value|
      norm += value * value
    end
    norm = Math.sqrt(norm)
    h.each do |key, value|
      h[key] = value / norm
    end
    return h
  end
end
