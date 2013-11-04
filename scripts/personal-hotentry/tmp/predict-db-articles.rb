# coding: utf-8
require './lib/personal-hotentry.rb'

ph_inst = PersonalHotentry.instance
Article.all.each do |a|
  contents = a.title
  if a.get_top_rated_summary
    #contents += " " + a.get_top_rated_summary.content
  end
  max_cluster_id, max_score = ph_inst.predict_max_cluster_id(contents)
  puts max_cluster_id.to_s + "\t" + a.title
  a.cluster_id = max_cluster_id
  a.save
end
