# encoding: utf-8
require './lib/text-analyzer.rb'
include TextAnalyzer

ma = MorphemeAnalyzer.instance
tf = ma.get_tf('吾輩は猫である。名前はまだ無い。1は2の前です。歩きます。')
tf.each do |term, freq|
  puts "#{term}\t#{freq}"
end
