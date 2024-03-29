# encoding: utf-8
ROOT_DIR = "."
TMP_DIR = ROOT_DIR + "/tmp/auto_summarize/learning"
DF_FILE = TMP_DIR + "/dict/idf_dict.txt"
INPUT_DIR = TMP_DIR + "/url_summary_contents"

class String
  def ngram n
    characters = self.split(//u)
    return [self] if characters.size <= n
    return 0.upto(characters.size-n).collect do |i|
      characters[i, n].join
    end
  end
end

def read_kv filename
  @read_hash = {}
  open(filename) do |f|
    f.each do |line|
      line = line.chomp
      @kv = line.split("\t")
      @read_hash[@kv[0]] = @kv[1].to_f
    end
  end
  return @read_hash
end

def idf term
  if IDF_DICT[term]
    return IDF_DICT[term]
  else
    return Math.log(@df_max.to_f / 1.0)
  end
end

def get_cosine_similarity a_hash, b_hash
  if !a_hash || !b_hash
    return 0.0
  end
  @a_power = 0.0
  a_hash.each do |key, value|
    @a_power += value*value
  end
  @a_power = Math.sqrt(@a_power)
  @b_power = 0.0
  b_hash.each do |key, value|
    @b_power += value*value
  end
  @b_power = Math.sqrt(@b_power)
  @dot_product = 0.0
  a_hash.each do |key, value|
    if b_hash[key]
      @dot_product += value * b_hash[key]
    end
  end
  if (@a_power*@b_power) != 0.0
    return @dot_product / (@a_power * @b_power)
  else
    return 0.0
  end
end

def sentence2liblinear s, label
  if s.length > 0 && s !~ /^\s+$/
    # s means one negative instance.
    # make features for s.
    @sum_idf = 0.0 # sum of idf score normalized by length
    @title_cosine = 0.0 # cosine similarity with title ngram.
    @s_length = s.length # length of this sentence.
    @s_prob  = 0.0 # probability of this sentence conditioned by the document.
    @s_tfidf = {}
    s.ngram(2).each do |term|
      @sum_idf += idf(term) / @s_length
      if @s_tfidf[term]
        @s_tfidf[term] += idf(term)
      else
        @s_tfidf[term]  = idf(term)
      end
      @s_prob += Math.log( get_tf(term, @tf_of_doc).to_f / @sum_tf_of_doc )
    end
    @s_prob = @s_prob / s.length
    if label > 0
      @label_s = "+1"
    else
      @label_s = "-1"
    end

    @length_key = 2
    case @s_length
    when 0
      @length_key += 0
    when 1..5
      @length_key += 1
    when 6..10
      @length_key += 2
    when 11..20
      @length_key += 3
    when 21..25
      @length_key += 4
    when 26..30
      @length_key += 5
    when 31..40
      @length_key += 6
    when 41..50
      @length_key += 7
    when 51..60
      @length_key += 8
    else
      @length_key += 9
    end

    puts @label_s + " 1:" + @sum_idf.to_s + " 2:" + get_cosine_similarity(@s_tfidf, @title_tfidf).to_s + " " + @length_key.to_s + ":1" + " 12:" +  @s_prob.to_s
    #puts @label_s + " 1:" + @sum_idf.to_s + " 2:" + get_cosine_similarity(@s_tfidf, @title_tfidf).to_s + " " + @length_key.to_s + ":1" + " 12:" +  @s_prob.to_s + "\t" + s
  end
end

def get_tf k, tf_hash
  if tf_hash[k]
    return tf_hash[k] + 1
  else
    return 1
  end
end

def replace_str str
  return str.gsub(/。/, "")
end

IDF_DICT = {}
@df = read_kv(DF_FILE)
@df_max = @df.max{ |x, y| x[1] <=> y[1] }[1]
@df.each do |df_i|
  IDF_DICT[df_i[0]] = Math.log(@df_max.to_f / (df_i[1]+1.0))
end

@tf_of_doc = {}
@sum_tf_of_doc = 0
Dir.glob(INPUT_DIR + "/????????/train_data_*.txt").each do |filename|
  @tf_of_doc = {}
  @sum_tf_of_doc = 0
  open(filename) do |f|
    f.each do |line|
      line = line.chomp
      line.split("").each do |p|
        p = p.gsub(/([\u300C][^\u300D]+[\u300D])/){ $1.gsub(/。/, "") }
        if p.length > 0
          p.split(/。/).each do |s|
            s.ngram(2).each do |k|
              @sum_tf_of_doc += 1
              if @tf_of_doc[k]
                @tf_of_doc[k] += 1
              else
                @tf_of_doc[k]  = 1
              end
            end
          end
        end
      end
    end
  end
  @sum_tf_of_doc += @tf_of_doc.length

  open(filename) do |f|
    @line_idx = 0
    @title_tfidf = {}
    f.each do |line|
      line = line.chomp
      case @line_idx
      when 0
        #title
        line.ngram(2).each do |k|
          if @title_tfidf[k]
            @title_tfidf[k] += idf(k)
          else
            @title_tfidf[k]  = idf(k)
          end
        end

      when 1
        #body
        line.split("").each do |p|
          p = p.gsub(/([\u300C][^\u300D]+[\u300D])/){ $1.gsub(/。/, "") }
          if p.length > 0
            p.split(/。/).each do |s|
              sentence2liblinear(s, -1)
            end
          end
        end

      when 2
        #summary
        line.split("").each do |p|
          p = p.gsub(/([\u300C][^\u300D]+[\u300D])/){ $1.gsub(/。/, "") }
          if p.length > 0
            p.split(/。/).each do |s|
              if s =~ /^\([^\)]+\)$/
                sentence2liblinear(s, -1)
              else
                if s.length < 6
                  sentence2liblinear(s, -1)
                else
                  sentence2liblinear(s,  1)
                end
              end
            end
          end
        end
      else
        #error
      end
      @line_idx += 1
    end
  end
end
