# coding: utf-8
require 'article_classifier/hash_extended'
require 'singleton'

class ArticleClassifier
  include Singleton

  MODEL_DIR = Rails.root.to_s + "/lib/article_classifier/model"
  DF_FILE = MODEL_DIR + "/df.txt"
  FEATURE_DICT_FILE = MODEL_DIR + "/feature_dict.txt"
  CLASS_DICT_FILE = MODEL_DIR + "/class_dict.txt"
  LIBLINEAR_MODEL_FILE = MODEL_DIR + "/liblinear.model"
  GRAM_SIZE = 2
  DOCUMENT_SIZE = 10000
  THRESHOLD = 0.0

  def initialize
    @df = Hash.new(1)
    @feature_dict = Hash.new()
    @class_dict = Hash.new()
    @is_trained = false
  end

  def add_train_data(class_name, text)
    text.force_encoding("UTF-8")
    unless @class_dict[class_name]
      @class_dict[class_name] = @class_dict.length
    end
    ng_ary = NgramsParser::ngram(text,GRAM_SIZE)
    tf = Hash.new(0)
    ng_ary.each do |ng|
      unless @feature_dict[ng]
        @feature_dict[ng] = @feature_dict.length + 1
      end
      tf[ng] += 1
    end
    tf.keys.each do |ng|
      @df[ng] += 1
    end
  end

  def save_dict_files
    @df.write_dict(DF_FILE)
    @feature_dict.write_dict(FEATURE_DICT_FILE)
    @class_dict.write_dict(CLASS_DICT_FILE)
  end

  def get_libsvm_label(class_name)
    return @class_dict[class_name]
  end

  def get_libsvm_hash(text)
    libsvm = Hash.new(0)
    text.force_encoding("UTF-8")
    ng_ary = NgramsParser::ngram(text,GRAM_SIZE)
    ng_ary.each do |ng|
      if @feature_dict[ng]
        libsvm[@feature_dict[ng]] += idf(ng)
      end
    end
    return libsvm
  end

  def read_models
    @df.read_kv(DF_FILE)
    @feature_dict.read_name_id(FEATURE_DICT_FILE)
    @class_dict.read_name_id(CLASS_DICT_FILE)
    read_liblinear_model(LIBLINEAR_MODEL_FILE)
    @is_trained = true
  end

  def predict(text)
    pred_class = 'other'
    pred_score = THRESHOLD
    unless @is_trained
      Rails.logger.error("[ArticleClassifier] predict method " +
                         "was called when the trained models " +
                         "were not read.")
      return pred_class
    end
    text.force_encoding("UTF-8")
    ngram_array = NgramsParser::ngram(text,GRAM_SIZE)
    @model.each do |class_name, weight_vector|
      score = 0.0
      ngram_array.each do |ngram|
        if weight_vector[ngram]
          score += idf(ngram) * weight_vector[ngram]
        end
      end
      if score > pred_score
        pred_score = score
        pred_class = class_name
      end
    end
    return pred_class
  end

  private
  def idf(ngram)
    if @df[ngram]
      return Math.log(DOCUMENT_SIZE / @df[ngram])
    else 
      return Math.log(DOCUMENT_SIZE)
    end
  end

  def read_liblinear_model(filename)
    @model = Hash.new()
    is_weight_start = false
    feature_id = 0
    open(filename) do |file|
      file.each do |line|
        line.chomp!
        if is_weight_start
          feature_id += 1
          feature_name = @feature_dict[feature_id]
          weight_array = line.split(" ")
          weight_array.each_with_index do |weight, class_id|
            class_name = @class_dict[class_id]
            unless @model[class_name]
              @model[class_name] = Hash.new()
            end
            if weight.to_f != 0
              @model[class_name][feature_name] = weight.to_f
            end
          end
        end
        if line =~ /^w$/
          is_weight_start = true
        end
      end
    end
  end
end
