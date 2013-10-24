# coding: utf-8
require './lib/personal-hotentry.rb'

ph_inst = PersonalHotentry.instance

Article.find(:all).each do |a|
  max_cluster_id = ph_inst.predict_max_cluster_id(a.title)

  puts max_cluster_id.to_s + "\t" + a.title
  a.cluster_id = max_cluster_id
  a.save
end
