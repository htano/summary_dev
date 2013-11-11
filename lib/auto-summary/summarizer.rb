# coding: utf-8
require 'open-uri'
require './lib/text-analyzer.rb'
require './lib/contents-extractor.rb'

class AutoSummary::Summarizer
  include TextAnalyzer
  include ContentsExtractor

  def initialize(params_dir, df_dir)
    @weight = read_hash(params_dir + WEIGHT_FILE)
    @center = read_hash(params_dir + CENTER_FILE)
    @scale  = read_hash(params_dir + SCALE_FILE)
    @title_df = DocumentFrequency.new(df_dir + TITLE_DF_FILE)
    @body_df = DocumentFrequency.new(df_dir + BODY_DF_FILE)
    @title_df.open_file
    @body_df.open_file
    @ext_factory = ExtractorFactory.instance
  end

  def run(url, html = nil)
    unless html
      html = get_html(url)
      unless html
        return nil
      end
    end
    contents_extractor = @ext_factory.new_extractor(url)
    contents_extractor.analyze!(html)
    feature_extractor = FeatureExtractor.new(
      contents_extractor.get_title,
      contents_extractor.get_body_sentence_array,
      @title_df,
      @body_df
    )
    #TODO: sentences_with_scoreを作る
    #TODO: summaryを作る
  end

  private
  def get_html(url)
    begin
      html = open(url) do |f|
        f.read
      end
      html = html.force_encoding("UTF-8")
      html = html.encode("UTF-8", "UTF-8")
      return html
    rescue => e
      Rails.logger.error("openuri: " + e.message)
      return nil
    end
  end

  def get_score(features)
  end

  def read_hash(filename)
    h = Hash.new
    open(filename) do |f|
      f.each do |line|
        line.chomp!
        k, v = line.split("\t")
        h[k] = v.to_f
      end
    end
  end
end
