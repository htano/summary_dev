# encoding: utf-8
require './lib/text-analyzer.rb'
include TextAnalyzer

TITLE_LIST_FILE = Rails.root.to_s + 
  "/tmp/article_classifier/learning/title_with_class.txt"
BODY_LIST_FILE = Rails.root.to_s +
  "/tmp/personal-hotentry/tmp/bayon-train.txt"

TITLE_DF_FILE = Rails.root.to_s + 
  "/lib/text-analyzer/df_dict/title-df.txt"
BODY_DF_FILE = Rails.root.to_s + 
  "/lib/text-analyzer/df_dict/body-df.txt"

title_df = DocumentFrequency.new(TITLE_DF_FILE)
open(TITLE_LIST_FILE) do |file|
  file.each do |line|
    line.chomp!
    class_name, title = line.split("\t")
    title_df.add_text(title)
  end
end
title_df.save_file

body_df = DocumentFrequency.new(BODY_DF_FILE)
open(BODY_LIST_FILE) do |file|
  file.each do |line|
    line.chomp!
    title, *tf_scores = line.split("\t")
    tf = Hash.new(0)
    0.step(tf_scores.length-1, 2) do |i|
      tf[tf_scores[i]] = tf_scores[i+1].to_f
    end
    body_df.add_ngram(tf)
  end
end
body_df.save_file
