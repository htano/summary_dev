# coding: utf-8
require './lib/text-analyzer.rb'
include TextAnalyzer

BODY_DF_FILE = Rails.root.to_s + 
  "/lib/text-analyzer/df_dict/body-df.txt"
BAYON_DATA_FILE = Rails.root.to_s +
  "/tmp/personal-hotentry/tmp/bayon-train.txt"
df = DocumentFrequency.new(BODY_DF_FILE)
df.open_file
open(BAYON_DATA_FILE) do |file|
  file.each do |line|
    line.chomp!
    title, *tf_scores = line.split("\t")
    tf = Hash.new(0)
    0.step(tf_scores.length-1, 2) do |i|
      tf[tf_scores[i]] = tf_scores[i+1].to_f
    end
    svd = df.tf2svd(tf)
    svd_line = ""
    svd.sort_by{|k,v| k}.each do |k,v|
      if v > 0.0
        svd_line += "#{k}:#{v} "
      end
    end
    svd_line.gsub!(/ +$/, "")
    puts svd_line
  end
end
