# coding: utf-8
require './lib/personal-hotentry.rb'
require './lib/article_classifier.rb'

TMP_DIR = Rails.root.to_s + "/tmp/personal-hotentry/tmp"
TITLE_URL_FILE = TMP_DIR + "/title-url.txt"

ph_inst = PersonalHotentry.new
ac_inst = ArticleClassifier.new
ac_inst.read_models
open(TITLE_URL_FILE) do |file|
  file.each do |line|
    line.chomp!
    title, url = line.split("\t")
    max_cluster_id, max_score =
      ph_inst.predict_max_cluster_id(title)
    category_name = ac_inst.predict(title)
    category_id = Category.find_by_name(category_name).id
    puts category_name + "\t" + max_cluster_id.to_s + "\t" + title
    Article.create(
      url: url,
      title: title,
      last_added_at: Time.now,
      strength: 0.1,
      cluster_id: max_cluster_id,
      category_id: category_id
    )
  end
end
