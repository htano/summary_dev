# coding: utf-8
TITLE_SVD_FILE = Rails.root.to_s +
  "/tmp/personal-hotentry/tmp/svd-test/train-title-feature.txt"
SVD_S_FILE = Rails.root.to_s +
  "/tmp/personal-hotentry/tmp/svd-test/data.S"

svd_s = Array.new
open(SVD_S_FILE) do |file|
  file.each do |line|
    line.chomp!
    svd_s.push(Math.sqrt(line.to_f))
  end
end

open(TITLE_SVD_FILE) do |file|
  file.each do |line|
    line.chomp!
    title, svd_line = line.split("\t")
    svd_u = svd_line.split(" ")
    print title
    svd_u.each_with_index do |val_s, id|
      val = val_s.to_f * svd_s[id]
      print "\t#{id}\t#{val}"
    end
    print "\n"
  end
end
