# coding: utf-8
class ContentsExtractor::Paragraph
  def initialize
    @sentences = Array.new
  end

  def add_sentence(s)
    @sentences.push(s)
  end

  def get_length
    return @sentences.length
  end

  def get_text
    sentence_text = ""
    @sentences.each do |s|
      sentence_text += s
    end
    return sentence_text
  end

  def get_sentence_array
    return @sentences
  end
end
