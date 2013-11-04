# coding: utf-8
require './lib/article_classifier.rb'

TMP_DIR = Rails.root.to_s + "/tmp/article_classifier/learning"
TRAIN_DATA = TMP_DIR + "/title_with_class.txt"
TRAIN_LIBSVM = TMP_DIR + "/libsvm.txt"

ac_inst = ArticleClassifier.instance
# make feature, class and df dictionary
open(TRAIN_DATA) do |file|
  file.each do |line|
    line.chomp!
    class_name, title = line.split("\t")
    ac_inst.add_train_data(class_name, title)
  end
end
ac_inst.save_dict_files

# make libsvm file
open(TRAIN_LIBSVM, "w") do |outfile|
  open(TRAIN_DATA) do |file|
    file.each do |line|
      line.chomp!
      class_name, title = line.split("\t")
      class_label = ac_inst.get_libsvm_label(class_name)
      libsvm_hash = ac_inst.get_libsvm_hash(title)
      outfile.write(class_label)
      libsvm_hash.sort.each do |k,v|
        outfile.write(" " + k.to_s + ":" + v.to_s)
      end
      outfile.write("\n")
    end
  end
end

