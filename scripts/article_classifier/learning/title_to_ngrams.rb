# coding: utf-8
require './lib/article_classifier.rb'

TMP_DIR = "tmp/article_classifier/learning"
CLASS_TITLE_DATA = TMP_DIR + "/title_with_class.txt"

open(CLASS_TITLE_DATA) do |file|
  file.each do |line|
    line.chomp!
    @class, @title = line.split("\t")
    @title.force_encoding("UTF-8")
    puts @class + "\t" + 
      ArticleClassifier::get_joined_ngrams(@title)
  end
end
