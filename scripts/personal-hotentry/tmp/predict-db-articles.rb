# coding: utf-8
require './lib/personal-hotentry.rb'

ph_inst = PersonalHotentry.new
Article.all.each do |a|
  contents = a.get_contents_text
  max_cluster_id, max_score = 
    ph_inst.predict_max_cluster_id(contents)
  if max_cluster_id && a.title
    puts max_cluster_id.to_s + "\t" + max_score.to_s + "\t" + a.title
    warn(max_cluster_id.to_s + "\t" + max_score.to_s + "\t" + a.title)
  end
  a.cluster_id = max_cluster_id
  a.save
end
