# encoding: utf-8
require './lib/auto-summary.rb'
include AutoSummary

DF_DIR = Rails.root.to_s + "/lib/text-analyzer/df_dict"
IN_DIR = Rails.root.to_s + "/tmp/auto_summarize/learning" + 
  "/url_summary_contents"

train = Trainer.new(DF_DIR)
Dir.glob(IN_DIR + "/????????/train_data_*.txt").each do |filename|

  line_idx = 0
  title = String.new
  body_array = Array.new
  positive_array = Array.new
  negative_array = Array.new
  open(filename) do |f|
    f.each do |line|
      line.chomp!
      case line_idx
      when 0
        #title
        title = line

      when 1
        #body
        line.split("").each do |p|
          p = p.gsub(/([\u300C][^\u300D]+[\u300D])/){
            $1.gsub(/。/, "")
          }
          if p.length > 0
            p.split(/。/).each do |s|
              s.gsub!(//, "。")
              body_array.push(s)
              negative_array.push(s)
            end
          end
        end

      when 2
        #summary
        line.split("").each do |p|
          p = p.gsub(/([\u300C][^\u300D]+[\u300D])/){
            $1.gsub(/。/, "")
          }
          if p.length > 0
            p.split(/。/).each do |s|
              body_array.push(s)
              if s =~ /^\([^\)]+\)$/
                negative_array.push(s)
              else
                if s.length < 6
                  negative_array.push(s)
                else
                  positive_array.push(s)
                  positive_array.push(s)
                  positive_array.push(s)
                end
              end
            end
          end
        end
        train.print_liblinears_of_webpage(
          title, 
          body_array,
          positive_array,
          negative_array
        ) 

      else
        #error
      end
      line_idx += 1
    end
  end
end
