# coding: utf-8
class TextAnalyzer::DocumentFrequency
  include TextAnalyzer
  DOCUMENT_SIZE = 20000
  MAX_DF_NUM = 2000

  def initialize(filename)
    @filename = filename
    @df = Hash.new(1)
    @index = Hash.new
  end

  def save_file
    idx = 1
    open(@filename, "w") do |file|
      @df.each do |k,v|
        file.write(k.to_s + "\t" + 
                   v.to_s + "\t" + 
                   idx.to_s + "\n")
        idx += 1
      end
    end
  end

  def open_file
    open(@filename) do |file|
      file.each do |line|
        line.chomp!
        k,v,idx = line.split("\t")
        @df[k] = v.to_f
        @index[k] = idx.to_i
      end
    end
  end

  def get_index(term)
    return @index[term]
  end

  def idf(term)
    if @df[term]
      if @df[term] > MAX_DF_NUM
        return 0.0
      else
        return Math.log(DOCUMENT_SIZE / @df[term])
      end
    else 
      return Math.log(DOCUMENT_SIZE)
    end
  end

  def tfidf(sentence)
    tf = get_tf(sentence)
    return tf2tfidf(tf)
  end

  def tf2tfidf(tf)
    tfidf = Hash.new
    tf.each do |term, freq|
      tfidf[term] = freq * idf(term)
    end
    return tfidf
  end

  def tf2svd(tf)
    svd = Hash.new
    tf.each do |term, freq|
      if @index[term]
        svd[@index[term]] = freq * idf(term)
      end
    end
    return svd
  end

  def add_text(text)
    text.force_encoding("UTF-8")
    tf = get_tf(text)
    tf.keys.each do |ng|
      @df[ng] += 1
    end
  end

  def add_ngram(tf)
    tf.keys.each do |ng|
      @df[ng] += 1
    end
  end
end
