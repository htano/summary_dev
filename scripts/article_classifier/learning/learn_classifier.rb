# coding: utf-8
require 'stuff-classifier'
require './lib/article_classifier.rb'

TMP_DIR = "tmp/article_classifier/learning"
TRAIN_DATA = TMP_DIR + "/20131017/title_with_class.txt"
TEST_DATA  = TMP_DIR + "/20131018/title_with_class.txt"
CLASSIFIER_STORAGE_PATH = TMP_DIR + "/ArticleClassifier.cls"

#store = StuffClassifier::FileStorage.new(CLASSIFIER_STORAGE_PATH)
#StuffClassifier::Base.storage = store
cls = StuffClassifier::Bayes.new("ArticleClassifier",
                                 :stemming => false)
open(TRAIN_DATA) do |file|
  file.each do |line|
    line.chomp!
    @class, @title = line.split("\t")
    @title.force_encoding("UTF-8")
    @ng_title = ArticleClassifier::get_joined_ngrams(@title)
    cls.train(@class, @ng_title)
  end
end
p cls

#cls = StuffClassifier::TfIdf.open("ArticleClassifier")
#open(TEST_DATA) do |file|
#  file.each do |line|
#    line.chomp!
#    @class, @title = line.split("\t")
#    @title.force_encoding("UTF-8")
#    @ng_title = ArticleClassifier::get_joined_ngrams(@title)
#    @predicted_class = cls.classify(@ng_title)
#    if @predicted_class
#      puts @class + "\t" + @predicted_class + "\t" + @title
#    else
#      puts @class + "\t" + "(default)" + "\t" + @title
#    end
#  end
#end
