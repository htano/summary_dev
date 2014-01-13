# coding: utf-8
class TextAnalyzer::DocumentFrequency
  include TextAnalyzer
  DOCUMENT_SIZE = 50000
  MAX_DF_NUM = DOCUMENT_SIZE / 10
  MIN_DF_NUM = DOCUMENT_SIZE / 10000

  def initialize(filename)
    @ma = MorphemeAnalyzer.instance
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
        if v.to_f > MIN_DF_NUM
          @df[k] = v.to_f
          @index[k] = idx.to_i
        end
      end
    end
  end

  def get_index(term)
    return @index[term]
  end

  def idf(term)
    if term =~ /^[wｗ]{3,9999}$/
      return 0.0
    end
    if @df[term]
      if @df[term] > MAX_DF_NUM
        return 0.0
      else
        return Math.log(DOCUMENT_SIZE / @df[term])
      end
    else 
      return Math.log(DOCUMENT_SIZE / MIN_DF_NUM)
    end
  end

  def tfidf(sentence)
    tf = @ma.get_tf(sentence)
    return tf2tfidf(tf)
  end

  def tf2tfidf(tf)
    tfidf = Hash.new
    tf.each do |term, freq|
      tfidf[term] = freq * idf(term)
    end
    return tfidf
  end

  def tfidf_from_sentence_array(s_ary)
    tf = Hash.new(0)
    s_ary.each do |s|
      s.force_encoding("UTF-8")
      tf_tmp = @ma.get_tf(s)
      tf_tmp.each do |term, freq|
        tf[term] += freq
      end
    end
    return tf2tfidf(tf)
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

  def add_sentence_array(s_ary)
    tf = Hash.new(0)
    s_ary.each do |s|
      s.force_encoding("UTF-8")
      tf_tmp = @ma.get_tf(s)
      tf_tmp.each do |term, freq|
        tf[term] += freq
      end
    end
    tf.keys.each do |ng|
      @df[ng] += 1
    end
  end

  def add_text(text)
    text.force_encoding("UTF-8")
    tf = @ma.get_tf(text)
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
