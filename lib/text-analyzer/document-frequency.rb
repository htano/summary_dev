# coding: utf-8
class TextAnalyzer::DocumentFrequency
  GRAM_SIZE = 2
  DOCUMENT_SIZE = 10000

  def initialize(filename)
    @filename = filename
    @df = Hash.new(1)
  end

  def save_file
    open(@filename, "w") do |file|
      @df.each do |k,v|
        file.write(k.to_s + "\t" + v.to_s + "\n")
      end
    end
  end

  def open_file
    open(@filename) do |file|
      file.each do |line|
        line.chomp!
        k,v = line.split("\t")
        @df[k] = v.to_f
      end
    end
  end

  def idf(term)
    if @df[term]
      return Math.log(DOCUMENT_SIZE / @df[term])
    else 
      return Math.log(DOCUMENT_SIZE)
    end
  end

  def add_text(text)
    text.force_encoding("UTF-8")
    ng_ary = NgramsParser::ngram(text,GRAM_SIZE)
    tf = Hash.new(0)
    ng_ary.each do |ng|
      tf[ng] += 1
    end
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
