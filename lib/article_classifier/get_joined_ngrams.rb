# coding: utf-8
module ArticleClassifier
  GRAM_SIZE = 3
  def self.get_joined_ngrams(text)
    @new_text = text.gsub(" ", "")
    @ngram_array = NgramsParser::ngram(@new_text, GRAM_SIZE)
    @ngram_array.map! do |item|
      item.gsub(" ", "")
    end
    return @ngram_array.join(" ")
  end
end
