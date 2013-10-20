# coding: utf-8
require './lib/article_classifier.rb'

ArticleClassifier.instance.read_models
Article.find(:all).each do |a|
  category_name = ArticleClassifier.instance.predict(a.title)
  puts category_name + "\t" + a.title
  a.category_id = Category.find_by_name(category_name).id
  a.save
end
