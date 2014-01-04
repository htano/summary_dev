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
OUTPUT_DIR = "#{Rails.root}/tmp/daily-tasks/common/#{day.to_s}"
MAX_TERM_NUM = 50

begin
  FileUtils.mkdir_p(OUTPUT_DIR)
rescue => err
  Rails.logger.info("[mklist-class-title-url] #{err}")
end

factory = ExtractorFactory.instance
df = DocumentFrequency.new(BODY_DF_FILE)
df.open_file

ofile = File.open("#{OUTPUT_DIR}/class-title-url-tfidf.txt","w")
open(DATAFILE) do |file|
  file.each_with_index do |line, idx|
    line.chomp!
    class_name, title, url = line.split("\t")
    warn("#{idx}: #{title}")
    extractor = factory.new_extractor(url)
    html = extractor.openurl_wrapper(url)
    unless html
      warn("openuri error: #{url}")
      next
    end
    begin
      extractor.analyze!(html)
    rescue => err_o
      warn("[mklist_tfidf:analyze] #{url}: #{err_o}")
      next
    end
    body_ary = extractor.get_body_sentence_array
    contents_ary = Array.new
    contents_ary.push(title)
    contents_ary.push(title)
    if body_ary
      contents_ary += body_ary
    end
    tfidf_hash = df.tfidf_from_sentence_array(contents_ary)
    ofile.write("#{class_name}")
    ofile.write("#{title}")
    ofile.write("#{url}")
    tfidf_hash.sort_by{|term, tfidf|
      -tfidf
    }.each_with_index do |(term, tfidf), tidx|
      if tidx < MAX_TERM_NUM
        if tfidf > 0.0
          ofile.write("#{term}#{tfidf.to_s}")
        end
      end
    end
    ofile.write("\n")
  end
end

ofile.close
