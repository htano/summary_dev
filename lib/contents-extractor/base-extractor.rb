# coding: utf-8
require 'open-uri'

class ContentsExtractor::BaseExtractor
  def initialize(xpath = nil, encoding = nil)
    @html = nil
    @title = ""
    @body = Array.new
    @error_status = nil
    @xpath = xpath
    @encoding = encoding
  end

  def analyze!(html)
    Rails.logger.error(
      "Called abstract method: analyze!"
    )
    @error_status = "called_abstract"
    return false
  end

  def openurl_wrapper(url)
    html = nil
    begin
      case @encoding
      when 'utf-8'
        html = open(url) do |f|
          f.read
        end
      #when 'euc-jp'
      #when 'shift_jis'
      else
        html = open(url, "r:binary") do |f|
          charset = f.charset
          Rails.logger.info("[openurl_wrapper] #{url}:#{charset}")
          if charset == "iso-8859-1"
            f.read
          else
            f.read.encode("utf-8", 
                          charset, 
                          :invalid => :replace, 
                          :undef => :replace)
          end
        end
      end
    rescue => err
      Rails.logger.warn("[ContentsExtractor:get_html] " +
                        "openuri error has occured at " + 
                        "#{url}: #{err}")
    end
    return html
  end

  def get_error_status
    return @error_status
  end

  def get_title
    if @html
      return @title
    else
      return nil
    end
  end

  def get_body_text
    unless @html
      return nil
    end
    body_text = ""
    @body.each do |p_obj|
      body_text += p_obj.get_text + "\n\n"
    end
    return body_text
  end

  def get_body_sentence_array
    unless @html
      return nil
    end
    body_sentences = Array.new
    @body.each do |p_obj|
      body_sentences += p_obj.get_sentence_array
    end
    return body_sentences
  end

  private
  def encode_utf8(html)
    case @encoding
    when 'utf-8'
      #No encoding
    when 'euc-jp'
      html = html.encode("UTF-8", "EUC-JP",
                         :invalid => :replace,
                         :undef => :replace, 
                         :replace => "?")
    when 'shift_jis'
      html = html.encode("UTF-8", "Shift_JIS")
    else
      #Default force encoding
      html = html.force_encoding("UTF-8")
      html = html.encode("UTF-8", "UTF-8")
    end
    return html
  end

  def parse_text(body_text)
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
        $1.gsub(/[。]/, "") 
      }
      p.gsub!(/([\u0028][^\u0029]+[\u0029])/){
        $1.gsub(/[。]/, "") 
      }
      if p.length > 0
        next if p =~ /^\d+.*\d{4}.\d{2}.\d{2}.*ID.*$/;
        p_obj = ContentsExtractor::Paragraph.new
        p.split(/[。]/).each do |s|
          s.gsub!(/[\u3010][^\u3011]+[\u3011]/,"")
          s.gsub!(/[\u0028][^\u0029]+[\u0029]/,"")
          next if s =~ / \- GIGAZINE$/;
          next if s =~ /^\d+.*\d{4}.\d{2}.\d{2}.*ID.*$/;
          next if s =~ /^[\x20-\x7E]+$/;
          s.gsub!(/>>\d+/, "")
          s.gsub!(/(.)\1{3}\1+/, "")
          s.gsub!(/（?[\x21-\x7E]{15,9999}）?/, "")
          s.gsub!(/[wWｗＷ]{3,9999}$/, "")
          s.gsub!(/[ \u3000]+$/, "")
          s.gsub!(/^[ \u3000]+/, "")
          next if s.length <= 5;
          next if s =~ /^\(c\)[\x20-\x7E]+$/;
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
