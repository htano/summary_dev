# encoding: utf-8
require 'open-uri'
require "nokogiri"
ROOT_DIR = "."
LEARNING_DIR = ROOT_DIR + "/scripts/article_classifier/learning"
CONFIG_DIR = LEARNING_DIR + "/config/source_url"

Dir.glob(CONFIG_DIR + "/*.txt").each do |filename|
  class_name = File.basename(filename, ".txt")
  idx = 0
  open(filename) do |f|
    f.each do |line|
      if(idx == 0)
        idx += 1
        next
      end
      line.chomp!
      src_url, p_rule, xpath, ex_str = line.split("\t")
      p_start, p_step, p_end = p_rule.split(",")
      for i in (p_start.to_i..p_end.to_i).step(p_step.to_i) do
        url = src_url.gsub(/___PAGE_FROM___/, i.to_s)
        open(url) do |io|
          html = io.read
          begin
            html = html.force_encoding("UTF-8")
            html = html.encode("UTF-8", "UTF-8")
            doc = Nokogiri::HTML.parse(html)
            doc.xpath(xpath).each do |a|
              puts a.attribute("title").value + "\t" + a.attribute("href").value
            end
          rescue => e
          end
        end
      end
    end
  end
end
