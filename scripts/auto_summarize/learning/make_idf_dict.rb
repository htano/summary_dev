# encoding: utf-8

class String
  def ngram n
    characters = self.split(//u)
    return [self] if characters.size <= n
    return 0.upto(characters.size-n).collect do |i|
      characters[i, n].join
    end
  end
end

@df_hash = {}
Dir.glob("tmp/auto_summarize/learning/url_summary_contents/????????/train_data_*.txt").each do |filename|
  open(filename) do |f|
    f.each do |l|
      l = l.chomp
      l.split("").each do |p|
        p = p.gsub(/([\u300C][^\u300D]+[\u300D])/){ $1.gsub(/。/, "") }
        p.split("。").each do |s|
          @s_ngr = s.ngram(2)
          @s_ngr.each do |k|
            if @df_hash[k]
              @df_hash[k] += 1
            else
              @df_hash[k]  = 1
            end
          end
        end
      end
    end
  end
end

@df_hash = @df_hash.sort {|a,b| b[1]<=>a[1]}
@df_hash.each_with_index do |v, k|
  puts v[0] + "\t" + v[1].to_s
end
