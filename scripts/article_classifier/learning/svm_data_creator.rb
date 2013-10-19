# coding: utf-8
require './lib/article_classifier.rb'

TMP_DIR = "tmp/article_classifier/learning"
TRAIN_DATA = TMP_DIR + "/title_with_class.txt"
TRAIN_LIBSVM = TMP_DIR + "/libsvm.txt"

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
df.write_dict(ArticleClassifier::DF_FILE)
feature_dict.write_dict(ArticleClassifier::FEATURE_DICT_FILE)
class_dict.write_dict(ArticleClassifier::CLASS_DICT_FILE)

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

