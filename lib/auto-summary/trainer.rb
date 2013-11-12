# coding: utf-8
require 'open-uri'
require './lib/text-analyzer.rb'

class AutoSummary::Trainer
  include TextAnalyzer

  def initialize(df_dir)
    @title_df = DocumentFrequency.new(df_dir + TITLE_DF_FILE)
    @body_df = DocumentFrequency.new(df_dir + BODY_DF_FILE)
    @title_df.open_file
    @body_df.open_file
    @ext_factory = ExtractorFactory.instance
  end

  def print_liblinears_of_webpage(
    title,
    summary_array,
    body_array
  )
    feature_extractor = 
      FeatureExtractor.new(title, 
                           body_array, 
                           @title_df, 
                           @body_df)
    summary_array.each do |s|
      features = 
        feature_extractor.get_features(s)
      print "+1"
      features.each do |k,v|
        print " #{k}:#{v}"
      end
      print "\n"
    end
    body_array.each do |s|
      features = 
        feature_extractor.get_features(s)
      print "-1"
      features.each do |k,v|
        print " #{k}:#{v}"
      end
      print "\n"
    end
  end
end
