# coding: utf-8
require './lib/personal-hotentry.rb'

ph_inst = PersonalHotentry.new
Article.all.each do |a|
  contents = a.title + " " + a.title
  if a.get_top_rated_summary && a.get_top_rated_summary.content
    contents += " " + a.get_top_rated_summary.content
  end
  contents.gsub!(/\r?\n/, " ")
  max_cluster_id, max_score = 
    ph_inst.predict_max_cluster_id(contents)
  if max_cluster_id && a.title
    puts max_cluster_id.to_s + "\t" + a.title
    warn(max_cluster_id.to_s + "\t" + a.title)
  end
  a.cluster_id = max_cluster_id
  a.save
end
