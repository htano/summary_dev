# coding: utf-8
class ArticleClassifier
  GRAM_SIZE = 2
  DOCUMENT_SIZE = 2000
  def self.get_joined_ngrams(text)
    @new_text = text.gsub(" ", "")
    @ngram_array = NgramsParser::ngram(@new_text, GRAM_SIZE)
    @ngram_array.map! do |item|
      item.gsub(" ", "")
    end
    return @ngram_array.join(" ")
  end

  def self.idf(df_dict, ngram)
    if df_dict[ngram]
      return Math.log(DOCUMENT_SIZE / df_dict[ngram])
    else
      return Math.log(DOCUMENT_SIZE)
    end
  end
end
