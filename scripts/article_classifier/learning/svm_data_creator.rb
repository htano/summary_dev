# coding: utf-8
require './lib/article_classifier.rb'

TMP_DIR = "tmp/article_classifier/learning"
TRAIN_DATA = TMP_DIR + "/20131017/title_with_class.txt"
TEST_DATA  = TMP_DIR + "/20131018/title_with_class.txt"
TRAIN_LIBSVM = TMP_DIR + "/20131017/libsvm.txt"
TEST_LIBSVM  = TMP_DIR + "/20131018/libsvm.txt"
CLASSIFIER_STORAGE_PATH = TMP_DIR + "/model"
DF_FILE = CLASSIFIER_STORAGE_PATH + "/df.txt"
FEATURE_DICT_FILE = CLASSIFIER_STORAGE_PATH + "/feature_dict.txt"
CLASS_DICT_FILE = CLASSIFIER_STORAGE_PATH + "/class_dict.txt"

# make feature, class and df dictionary
df = Hash.new(1)
feature_dict = Hash.new()
class_dict = Hash.new()
open(TRAIN_DATA) do |file|
  file.each do |line|
    line.chomp!
    @class, @title = line.split("\t")
    @title.force_encoding("UTF-8")
    @ng_ary = NgramsParser::ngram(@title,
                                  ArticleClassifier::GRAM_SIZE)
    unless class_dict[@class]
      class_dict[@class] = class_dict.length
    end
    tf = Hash.new(0)
    @ng_ary.each do |ng|
      unless feature_dict[ng]
        feature_dict[ng] = feature_dict.length + 1
      end
      tf[ng] += 1
    end
    tf.keys.each do |ng|
      df[ng] += 1
    end
  end
end
df.write_dict(DF_FILE)
feature_dict.write_dict(FEATURE_DICT_FILE)
class_dict.write_dict(CLASS_DICT_FILE)

# make libsvm file
open(TRAIN_LIBSVM, "w") do |outfile|
  open(TRAIN_DATA) do |file|
    file.each do |line|
      @liblinear = Hash.new(0)
      line.chomp!
      @class, @title = line.split("\t")
      @title.force_encoding("UTF-8")
      @ng_ary = NgramsParser::ngram(@title, 
                                    ArticleClassifier::GRAM_SIZE)
      @ng_ary.each do |ng|
        if feature_dict[ng]
          @liblinear[feature_dict[ng]] += 
            ArticleClassifier::idf(df,ng)
        end
      end
      outfile.write(class_dict[@class])
      @liblinear.sort.each do |k,v|
        outfile.write(" " + k.to_s + ":" + v.to_s)
      end
      outfile.write("\n")
    end
  end
end

# make libsvm file
open(TEST_LIBSVM, "w") do |outfile|
  open(TEST_DATA) do |file|
    file.each do |line|
      @liblinear = Hash.new(0)
      line.chomp!
      @class, @title = line.split("\t")
      @title.force_encoding("UTF-8")
      @ng_ary = NgramsParser::ngram(@title, 
                                    ArticleClassifier::GRAM_SIZE)
      @ng_ary.each do |ng|
        if feature_dict[ng]
          @liblinear[feature_dict[ng]] += 
            ArticleClassifier::idf(df,ng)
        end
      end
      outfile.write(class_dict[@class])
      @liblinear.sort.each do |k,v|
        outfile.write(" " + k.to_s + ":" + v.to_s)
      end
      outfile.write("\n")
    end
  end
end

