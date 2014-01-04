# encoding: utf-8
require 'open-uri'
require "nokogiri"
require 'date'
day = Date::today
CONFIG_DIR = "#{Rails.root}/scripts/daily-tasks/common/config"
OUTPUT_DIR = "#{Rails.root}/tmp/daily-tasks/common/#{day.to_s}"
begin
  FileUtils.mkdir_p(OUTPUT_DIR)
rescue => err
  Rails.logger.info("[mklist-class-title-url] #{err}")
end
ofile = File.open("#{OUTPUT_DIR}/class-title-url.txt","w")
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
              ofile.write("#{class_name}\t" + 
                          "#{a.attribute("title").value}\t" + 
                          "#{a.attribute("href").value}\n")
            end
          rescue => e
          end
        end
      end
    end
  end
end
ofile.close