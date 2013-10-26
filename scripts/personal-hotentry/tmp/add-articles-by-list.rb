# coding: utf-8
require './lib/article_classifier.rb'

TMP_DIR = Rails.root.to_s + "/tmp/personal-hotentry/tmp"
TITLE_URL_FILE = TMP_DIR + "/title-url.txt"

open(TITLE_URL_FILE) do |file|
  file.each do |line|
    line.chomp!
    title, url = line.split("\t")
    Article.create(
      url: url,
      title: title,
      last_added_at: Time.now,
      strength: 1.0
    )
  end
end
