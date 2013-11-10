# encoding: utf-8
require './lib/text-analyzer.rb'
include TextAnalyzer

TMP_DIR = "tmp/test/text-analyzer/"
DF_FILE = TMP_DIR + "df.txt"
df = DocumentFrequency.new(DF_FILE)

df.add_text("あいうえおかきくけこ")
df.add_text("かきくけこさしすせそ")
df.add_text("さしすせそたちつてと")
df.add_text("たちつてとなにぬねの")
df.add_text("あいうえおかきくけこ")
df.add_text("あいうえおかきくけこ")

puts("あい: " + df.idf("あい").to_s)
df.save_file

df2 = DocumentFrequency.new(DF_FILE)
df2.open_file
puts("あい: " + df2.idf("あい").to_s)
