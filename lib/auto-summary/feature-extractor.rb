# coding: utf-8
require './lib/text-analyzer.rb'

class AutoSummary::FeatureExtractor
  include TextAnalyzer
  def initialize(title, doc_ary, title_df, body_df)
    @ma = MorphemeAnalyzer.instance
    @title = title
    @doc_array = doc_ary
    @title_df = title_df
    @body_df = body_df
    @title_tfidf = @title_df.tfidf(@title)
    @doc_tn = get_doc_tn
    @sum_doc_tn = get_sum_doc_tn
  end

  def get_features(sentence)
    features = Hash.new(0)
    features[1] = get_sumof_idf(sentence)
    features[2] = get_title_cosine(sentence)
    features[3] = get_generative_probability(sentence)
    features[get_length_key(sentence)] = 1.0
    return features
  end

  def sentence_cosine(str_a, str_b)
    tfidf_a = @body_df.tfidf(str_a)
    tfidf_b = @body_df.tfidf(str_b)
    cosine = get_cosine_similarity(tfidf_a, tfidf_b)
    return cosine
  end

  private
  def get_title_cosine(sentence)
    sectence_tfidf = @body_df.tfidf(sentence)
    cosine = get_cosine_similarity(@title_tfidf, sectence_tfidf)
    return cosine
    #if cosine > 0.8
    #  return -9999
    #else
    #  return cosine
    #end
  end

  def get_generative_probability(sentence)
    s_prob = 0.0
    term_num = 0
    @ma.get_tn(sentence).each do |ng, num|
      term_num += (num-1)
      s_prob += (num-1) * Math.log(get_probability(ng))
    end
    if term_num > 0
      s_prob = s_prob / term_num
      return s_prob
    else
      return -4.7
    end
  end

  def get_sumof_idf(sentence)
    sumof_idf = 0.0
    @ma.get_tf(sentence).each do |k,v|
      sumof_idf += @body_df.idf(k) / sentence.length
    end
    return sumof_idf
  end

  def get_length_key(sentence)
    case sentence.length
    when 1..5
      length_key = 4
    when 6..10
      length_key = 5
    when 11..20
      length_key = 6
    when 21..25
      length_key = 7
    when 26..30
      length_key = 8
    when 31..40
      length_key = 9
    when 41..60
      length_key = 10
    when 61..100
      length_key = 11
    else
      length_key = 12
    end
    return length_key
  end

  def get_doc_tn
    doc_tn = Hash.new(1)
    @doc_array.each do |sentence|
      @ma.get_tn(sentence).each do |ng, num|
        doc_tn[ng] += num
      end
    end
    return doc_tn
  end

  def get_sum_doc_tn
    sum_doc_tn = 1
    @doc_tn.each do |ng, num|
      sum_doc_tn += num
    end
    return sum_doc_tn
  end

  def get_probability(term)
    return @doc_tn[term].to_f / @sum_doc_tn
  end

  def get_cosine_similarity(a, b)
    a_norm = get_norm(a)
    b_norm = get_norm(b)
    cosine = 0.0
    if (a_norm * b_norm) != 0.0
      a.each do |k,v|
        if b[k]
          cosine += (v * b[k]) / (a_norm * b_norm)
        end
      end
    end
    return cosine
  end

  def get_norm(vec)
    power = 0.0
    vec.each do |k,v|
      power += v * v
    end
    return Math.sqrt(power)
  end
end
