# coding: utf-8
require 'article_classifier/hash_extended'
class ArticleClassifier
  MODEL_DIR = "./lib/article_classifier/model"
  DF_FILE = MODEL_DIR + "/df.txt"
  FEATURE_DICT_FILE = MODEL_DIR + "/feature_dict.txt"
  CLASS_DICT_FILE = MODEL_DIR + "/class_dict.txt"
  LIBLINEAR_MODEL_FILE = MODEL_DIR + "/liblinear.model"
  GRAM_SIZE = 2
  DOCUMENT_SIZE = 2000
  THRESHOLD = -1.0

  # TODO: 変えたいけど、まだ使っているから変えたらダメよ
  def self.idf(df_dict, ngram)
    if df_dict[ngram]
      return Math.log(DOCUMENT_SIZE / df_dict[ngram])
    else
      return Math.log(DOCUMENT_SIZE)
    end
  end

  def self.open(name)
    inst = self.new(name)
    inst.read_trained_objects
    return inst
  end

  def initialize(name)
    @name = name
    @df = Hash.new(1)
    @feature_dict = Hash.new()
    @class_dict = Hash.new()
  end

  def predict(text)
    pred_class = 'other'
    pred_score = THRESHOLD
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

  def read_trained_objects
    @df.read_kv(DF_FILE)
    @feature_dict.read_name_id(FEATURE_DICT_FILE)
    @class_dict.read_name_id(CLASS_DICT_FILE)
    read_liblinear_model(LIBLINEAR_MODEL_FILE)
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
            @model[class_name][feature_name] = weight.to_f
          end
        end
        if line =~ /^w$/
          is_weight_start = true
        end
      end
    end
  end
end


