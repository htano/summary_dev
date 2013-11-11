# coding: utf-8
require './lib/text-analyzer.rb'

class AutoSummary::FeatureExtractor
  def initialize(title, doc_ary, title_df, body_df)
    @title = title
    @doc_array = doc_ary
    @title_df = title_df
    @body_df = body_df
  end

  def get_features(sentence)
  end

  private
  def get_generative_probability(sentence)
  end

  def get_length_key(sentence)
  end

  def get_title_cosine(sentence)
  end

  def get_sumof_idf(sentence)
  end
end
