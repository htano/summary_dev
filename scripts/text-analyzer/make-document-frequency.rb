# encoding: utf-8
require './lib/text-analyzer.rb'
require './lib/contents-extractor.rb'
require "open-uri"
include TextAnalyzer

TITLE_LIST_FILE = Rails.root.to_s + 
  "/tmp/article_classifier/learning/title_with_class.txt"
TITLE_WITH_URL = Rails.root.to_s +
  "/tmp/personal-hotentry/tmp/title-url.txt"

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

factory = ContentsExtractor::ExtractorFactory.instance
body_df = DocumentFrequency.new(BODY_DF_FILE)
open(TITLE_WITH_URL) do |file|
  file.each_with_index do |line, idx|
    line.chomp!
    title, url = line.split("\t")
    contents_ary = Array.new
    contents_ary.push(title)
    warn("#{idx}: #{title}")
    begin
      html = open(url) do |f|
        f.read
      end
    rescue
      warn("openuri error: #{url}")
      next
    end
    extractor = factory.new_extractor(url)
    extractor.analyze!(html)
    body_ary = extractor.get_body_sentence_array
    if body_ary
      contents_ary += body_ary
    end
    body_df.add_sentence_array(contents_ary)
  end
end
body_df.save_file
