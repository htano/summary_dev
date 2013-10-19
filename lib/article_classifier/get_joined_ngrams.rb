# coding: utf-8
class ArticleClassifier
  GRAM_SIZE = 2
  DOCUMENT_SIZE = 2000

  # TODO: 変えたいけど、まだ使っているから変えたらダメよ
  def self.idf(df_dict, ngram)
    if df_dict[ngram]
      return Math.log(DOCUMENT_SIZE / df_dict[ngram])
    else
      return Math.log(DOCUMENT_SIZE)
    end
  end
end
