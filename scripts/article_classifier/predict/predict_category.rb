# coding: utf-8
require './lib/article_classifier.rb'

ac_inst = ArticleClassifier.new
ac_inst.read_models
Article.find(:all).each do |a|
  category_name = ac_inst.predict(a.title)
  puts category_name + "\t" + a.title
  a.category_id = Category.find_by_name(category_name).id
  a.save
end
