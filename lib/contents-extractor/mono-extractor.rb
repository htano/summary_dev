# coding: utf-8
require 'bundler/setup'
require 'extractcontent'
require 'nokogiri'

class ContentsExtractor::MonoExtractor < ContentsExtractor::BaseExtractor
  def analyze!(html)
    html = html.force_encoding("UTF-8")
    html = html.encode("UTF-8", "UTF-8")
    @html = html
    body_text = ""
    begin
      body_text, @title = ExtractContent.analyse(@html)
    rescue
      doc = Nokogiri::HTML.parse(@html)
      @title = doc.title
      doc.xpath('//p').each do |d| 
        body_text += d.text + "\n"
      end 
    end 
    # Error Checking & Handling
    begin
      @title.split("")
      body_text.split("")
    rescue => err
      @error_status = "encoding"
      Rails.logger.info(
        "A page has invalid encoding: " + err.message
      )
      return false
    end
    body_text.gsub!(/\r/, "")
    body_text.split("\n").each do |p|
      p.gsub!(/([\u300C][^\u300D]+[\u300D])/){
        $1.gsub(/[。．]/, "") 
      }
      if p.length > 0
        p_obj = ContentsExtractor::Paragraph.new
        p.split(/[。．]/).each do |s|
          next if s =~ /^\d+.*\d{4}.\d{2}.\d{2}.*ID.*$/;
          s.gsub!(/(.)\1{3}\1+/, "")
          next if s.length <= 5;
          #s.gsub!(/[ 　]/, "")
          s.gsub!(//, "。")
          p_obj.add_sentence(s + "。")
        end
        if p_obj.get_length > 0
          @body.push(p_obj)
        end
      end
    end
    return true
  end
end
