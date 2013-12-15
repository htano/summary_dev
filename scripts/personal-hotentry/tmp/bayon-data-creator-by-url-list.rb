# coding: utf-8
require './lib/article_classifier.rb'
require './lib/contents-extractor.rb'
require './lib/text-analyzer.rb'
require "open-uri"
include TextAnalyzer

OUTPUT_FILE = Rails.root.to_s + "/" + ENV['OUT']

BODY_DF_FILE = Rails.root.to_s + 
  "/lib/text-analyzer/df_dict/body-df.txt"
TITLE_WITH_URL = Rails.root.to_s +
  "/tmp/personal-hotentry/tmp/title-url.txt"
MAX_TERM_NUM = 50

df = DocumentFrequency.new(BODY_DF_FILE)
df.open_file
factory = ContentsExtractor::ExtractorFactory.instance
file_o = open(OUTPUT_FILE, "w")
open(TITLE_WITH_URL) do |file_i|
  file_i.each_with_index do |line, idx|
    line.chomp!
    title, url = line.split("\t")
    contents_ary = Array.new
    contents_ary.push(title)
    contents_ary.push(title)
    warn("#{idx}: #{title}")
    begin
      html = open(url) do |f|
        f.read
      end
    rescue => e
      warn("openuri error: #{url}")
      next
    end
    extractor = factory.new_extractor(url)
    extractor.analyze!(html)
    body_ary = extractor.get_body_sentence_array
    if body_ary
      contents_ary += body_ary
    end
    tfidf_hash = df.tfidf_from_sentence_array(contents_ary)
    file_o.write(title)
    i = 0
    tfidf_hash.sort_by{|key, value| 
      -value
    }.each do |ng,tfidf|
      if i < MAX_TERM_NUM
        if tfidf > 0.0
          file_o.write("\t#{ng}\t#{tfidf}")
        end
      end
      i += 1
    end
    file_o.write("\n")
  end
end
file_o.close
