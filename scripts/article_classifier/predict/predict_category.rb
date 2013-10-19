# coding: utf-8
require './lib/article_classifier.rb'

ac = ArticleClassifier::open("A")
Article.find(:all).each do |a|
  category_name = ac.predict(a.title)
  puts category_name + "\t" + a.title
  a.category_id = Category.find_by_name(category_name).id
  a.save
end
