# encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'extractcontent'
# require 'openssl'
# require 'uri'

ROOT_DIR = "."
TMP_DIR = ROOT_DIR + "/scripts/auto_summarize/predict"
DF_FILE = TMP_DIR + "/dict/idf_dict.txt"
PARAMS_DIR = TMP_DIR + "/params"
WEIGHTS_FILE = PARAMS_DIR + "/feature_weights.txt"
CENTER_FILE = PARAMS_DIR + "/feature_center.txt"
SCALE_FILE = PARAMS_DIR + "/feature_scale.txt"

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

IDF_DICT = {}
@df = read_kv(DF_FILE)
@df.each do |df_i|
  IDF_DICT[df_i[0]] = Math.log(400/(df_i[1]+1.0))
end

def idf term
  if IDF_DICT[term]
    return IDF_DICT[term]
  else
    return Math.log(400.0/10.0)
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

def extract_features s
  if s.length > 0 && s !~ /^\s+$/
    # s means one negative instance.
    # make features for s.
    @sum_idf = 0.0 # sum of idf score normalized by length
    @title_cosine = 0.0 # cosine similarity with title ngram.
    @s_length = s.length.to_f # length of this sentence.
    @s_tfidf = {}
    s.ngram(2).each do |term|
      @sum_idf += idf(term) / @s_length
      if @s_tfidf[term]
        @s_tfidf[term] += idf(term)
      else
        @s_tfidf[term]  = idf(term)
      end
    end
    @title_cosine = get_cosine_similarity(@s_tfidf, @title_tfidf)
    return {"sum_idf" => @sum_idf, "title_cosine" => @title_cosine, "s_length" => @s_length}
  else
    return nil
  end
end


@svm_weight = read_kv WEIGHTS_FILE
@svm_center = read_kv CENTER_FILE
@svm_scale  = read_kv SCALE_FILE

def get_score features
  @score = 0.0
  if features
    features.each do |k,v|
      if @svm_scale[k] != 0
        @score += @svm_weight[k] * ((v - @svm_center[k]) / @svm_scale[k])
      end
    end
    return @score
  else
    return nil
  end
end

@title_tfidf = nil
Article.getHotEntryArtileList.each do |e|
  @user = User.find_by_name("system001")
  if @user
    @summary_model = e.summaries.find_by_user_id(User.find_by_name("system001").id)
    if @summary_model
      Rails.logger.info "Auto summary has aleady existed.: " + e.id.to_s
      next
    end
  else
    Rails.logger.error "system001 is not exists."
    break
  end

  body  = ""
  title = ""
  doc = nil

  begin
    charset = nil
    html = open(e.url) do |f|
      charset = f.charset
      f.read
    end
    html = html.force_encoding("UTF-8")
    html = html.encode("UTF-8", "UTF-8")
  rescue => err
    p err
    Rails.logger.error "openuri: " + err.message
    next
  end

  # はてなのアノニマスダイアリみたいに、ExtractContentでエラーなく取得できるけど
  # いい感じに取れないサイトは強制的にnokogiriで取得するようにしたい
  # 強制nokogiriサイトリストを作成して、それを読み込むようにする
  @force_nokogiri = false
  if !@force_nokogiri
    begin
      body, title = ExtractContent.analyse(html)
    rescue
      doc = Nokogiri::HTML.parse(html)
      title = doc.title
      doc.xpath('//p').each do |d|
        body += d.text + "\n"
      end
    end
  else
    doc = Nokogiri::HTML.parse(html)
    title = doc.title
    doc.xpath('//p').each do |d|
      body += d.text + "\n"
    end
  end

  begin
    title.split("")
    body.split("")
  rescue => err
    Rails.logger.error "A page has invalid encoding: " + err.message
    p err
    next
  end

  @title_tfidf = {}
  title.ngram(2).each do |k|
    if @title_tfidf[k]
      @title_tfidf[k] += idf(k)
    else
      @title_tfidf[k]  = idf(k)
    end
  end
  puts "[URL] " + e.url
  puts "[Title] " + title
  sentences_with_score = []
  idx = 0
  body.split("\n").each do |p|
    if p.length > 0
      p.split(/。/).each do |s|
        @s_features = extract_features(s)
        if @s_features
          #@s_score = @s_features[:title_cosine]
          @s_score = get_score(@s_features)
          if @s_score
            s_with_score = { :order => idx, :sen => s, :score => @s_score }
            sentences_with_score.push(s_with_score)
            idx += 1
          end
        end
      end
    end
  end
  summary_sentence = []
  sum_length = 0
  sentences_with_score.sort{|a,b| b[:score]<=>a[:score]}.each do |s_score|
    if sum_length + (s_score[:sen]+"。\n").length <= 300
      summary_sentence.push(s_score)
      sum_length += (s_score[:sen]+"。\n").length
    end
  end
  @summary_contents = ""
  summary_sentence.sort{|a,b| a[:order]<=>b[:order]}.each do |s_line|
    @summary_contents += s_line[:sen] + "。\n"
  end

  Summary.create( content:@summary_contents, user_id:@user.id, article_id:e.id )
  puts @summary_contents
  puts "\n"


end
