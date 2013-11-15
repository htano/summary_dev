# coding: utf-8

class ContentsExtractor::BaseExtractor
  def initialize
    @html = nil
    @title = ""
    @body = Array.new
    @error_status = nil
  end

  def analyze!(html)
    Rails.logger.error(
      "Called abstract method: analyze!"
    )
    @error_status = "called_abstract"
    return false
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
end
