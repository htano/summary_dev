# coding: utf-8
require './lib/article_classifier.rb'

ac = ArticleClassifier::open("A")
Article.find(:all).each do |a|
  category_name = ac.predict(a.title)
  puts category_name + "\t" + a.title
end
