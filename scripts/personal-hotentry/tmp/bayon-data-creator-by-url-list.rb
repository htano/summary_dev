# coding: utf-8
require './lib/article_classifier.rb'
require './lib/contents-extractor.rb'
require './lib/text-analyzer.rb'
require "open-uri"
include TextAnalyzer

BODY_DF_FILE = Rails.root.to_s + 
  "/lib/text-analyzer/df_dict/body-df.txt"
TITLE_WITH_URL = "tmp/personal-hotentry/tmp/title-url.txt"
GRAM_SIZE = 2
MAX_TERM_NUM = 100

df = DocumentFrequency.new(BODY_DF_FILE)
df.open_file
factory = ContentsExtractor::ExtractorFactory.instance
open(TITLE_WITH_URL) do |file|
  file.each_with_index do |line, idx|
    line.chomp!
    title, url = line.split("\t")
    contents = title
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
    body = extractor.get_body_text
    if body
      contents += " " + body
    end
    contents.gsub!(/\r?\n/, " ")
    tfidf_hash = df.tfidf(contents)
    print(title)
    i = 0
    tfidf_hash.sort_by{|key, value| 
      -value
    }.each do |ng,tfidf|
      if i < MAX_TERM_NUM
        if tfidf > 0.0
          print("\t", ng, "\t", tfidf)
        end
      end
      i += 1
    end
    print("\n")
    warn(idx.to_s + ": " + title)
  end
end
