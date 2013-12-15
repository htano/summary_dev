module TextAnalyzer
#  GRAM_SIZE = 2
#
#  def get_tn(sentence)
#    tn = Hash.new(1)
#    ng_ary = NgramsParser::ngram(sentence, GRAM_SIZE)
#    ng_ary.each do |ng|
#      tn[ng] += 1
#    end
#    return tn
#  end
#
#  def get_tf(sentence)
#    tn_sum = 0
#    tn = Hash.new(0)
#    ng_ary = NgramsParser::ngram(sentence, GRAM_SIZE)
#    ng_ary.each do |ng|
#      tn[ng] += 1
#      tn_sum += 1
#    end
#    tf = Hash.new(0.0)
#    if tn_sum > 0
#      tn.each do |k,v|
#        tf[k] = v.to_f / tn_sum
#      end
#    end
#    return tf
#  end
  require 'text-analyzer/document-frequency'
  require 'text-analyzer/morpheme-analyzer'
end
