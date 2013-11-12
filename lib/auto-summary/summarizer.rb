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
    title = contents_extractor.get_title
    sentence_ary = contents_extractor.get_body_sentence_array
    feature_extractor = FeatureExtractor.new(title, 
                                             sentence_ary, 
                                             @title_df, 
                                             @body_df)
    sentences_with_score = make_sentences_with_score(
      sentence_ary,
      feature_extractor
    )
    summary_contents = get_summary_contents(sentences_with_score)
    if summary_contents.length > 0
      return summary_contents
    else
      return nil
    end
  end

  private
  def get_summary_contents(sentences_with_score)
    summary_sentences = Array.new
    summary_length = 0
    sentences_with_score.sort{|a,b|
      b[:score]<=>a[:score]
    }.each do |s_score|
      if sum_length + s_score[:sen].length <= 300
        summary_sentences.push(s_score)
        summary_length += s_score[:sen].length
      end
    end
    summary_contents = ""
    summary_sentences.sort{|a,b|
      a[:order]<=>b[:order]
    }.each do |s_line|
      summary_contents += s_line[:sen]
    end
    return summary_contents
  end

  def make_sentences_with_score(sentence_ary, feature_extractor)
    sentences_with_score = Array.new
    sentence_ary.each_with_index do |s, idx|
      features = get_features(s)
      s_score = get_score(features)
      s_with_score = {
        :order => idx,
        :sen => s,
        :score => s_score
      }
      sentences_with_score.push(s_with_score)
    end
    return sentences_with_score
  end

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
    score = 0.0
    if features
      features.each do |k, v|
        #k = k_plus_one - 1
        unless @scale[k] == 0
          score += @weight[k] * ((v - @center[k]) / @scale[k])
        end
      end
    end
    return score
  end

  def read_hash(filename)
    h = Hash.new
    open(filename) do |f|
      f.each_with_index do |value, key|
        value.chomp!
        h[key+1] = value.to_f
      end
    end
  end
end
