# encoding: utf-8
ROOT_DIR = "."
LEARNING_DIR = ROOT_DIR + "/scripts/text_classify/learning"
CONFIG_DIR = LEARNING_DIR + "/config/source_url"
TMP_DIR = ROOT_DIR + "/tmp/text_classify/learning"
OUTPUT_DIR = TMP_DIR + "/title_with_class"

class String
  def ngram n
    characters = self.split(//u)
    return [self] if characters.size <= n
    return 0.upto(characters.size-n).collect do |i|
      characters[i, n].join
    end
  end
end

Dir.glob(CONFIG_DIR + "/*.txt").each do |filename|
  @class_name = filename.gsub(/\.txt/, "")
  @idx = 0
  open(filename) do |f|
    f.each do |line|
      if(@idx == 0)
        @idx += 1
        next
      end
      line.chomp!
      @source_url,@p_rule,@xpath,@exclude_str = line.split("\t")
      @p_start,@p_interval,@p_end = @p_rule.split(",")
      for i in (@p_start.to_i..@p_end.to_i).step(@p_interval.to_i) do
        @url = @source_url.gsub(/___PAGE_FROM___/, i.to_s)
        puts @url
      end
    end
  end
end
