# encoding: utf-8
require './lib/text-analyzer.rb'
require './lib/contents-extractor.rb'
require 'date'
include TextAnalyzer
include ContentsExtractor

day = Date::today
DATAFILE = "#{Rails.root}/tmp/daily-tasks/" +
  "common/#{day.to_s}/class-title-url.txt"

TITLE_DF_FILE = Rails.root.to_s + 
  "/lib/text-analyzer/df_dict/title-df.txt"
BODY_DF_FILE = Rails.root.to_s + 
  "/lib/text-analyzer/df_dict/body-df.txt"

warn("running: #{TITLE_DF_FILE}")
title_df = DocumentFrequency.new(TITLE_DF_FILE)
title_df.open_file
open(DATAFILE) do |file|
  file.each do |line|
    line.chomp!
    class_name, title, url = line.split("\t")
    title_df.add_text(title)
  end
end
title_df.save_file

warn("running: #{BODY_DF_FILE}")
factory = ExtractorFactory.instance
body_df = DocumentFrequency.new(BODY_DF_FILE)
body_df.open_file
open(DATAFILE) do |file|
  file.each_with_index do |line, idx|
    line.chomp!
    class_name, title, url = line.split("\t")
    warn("#{idx}: #{title}")
    contents_ary = Array.new
    contents_ary.push(title)
    extractor = factory.new_extractor(url)
    html = extractor.openurl_wrapper(url)
    unless html
      warn("openuri error: #{url}")
      next
    end
    extractor.analyze!(html)
    body_ary = extractor.get_body_sentence_array
    if body_ary
      contents_ary += body_ary
    end
    body_df.add_sentence_array(contents_ary)
  end
end
body_df.save_file
