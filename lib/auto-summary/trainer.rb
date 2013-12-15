# coding: utf-8
require 'open-uri'
require './lib/text-analyzer.rb'

class AutoSummary::Trainer
  include TextAnalyzer
  include AutoSummary

  def initialize
    df_dir = DF_DIR
    @title_df = DocumentFrequency.new(df_dir + TITLE_DF_FILE)
    @body_df = DocumentFrequency.new(df_dir + BODY_DF_FILE)
    @title_df.open_file
    @body_df.open_file
  end

  def print_liblinears_of_webpage(
    title,
    body_array,
    positive_array,
    negative_array
  )
    feature_extractor = 
      FeatureExtractor.new(title, body_array, @title_df, @body_df)
    positive_array.each do |s|
      if s.length > 0
        features = feature_extractor.get_features(s)
        print "+1"
        features.each do |k,v|
          print " #{k}:#{v}"
        end
        print "\n"
      end
    end
    negative_array.each do |s|
      if s.length > 0
        features = feature_extractor.get_features(s)
        print "-1"
        features.each do |k,v|
          print " #{k}:#{v}"
        end
        print "\n"
      end
    end
  end
end
