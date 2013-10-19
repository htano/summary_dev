# coding: utf-8
class Hash
  def write_dict(filename)
    open(filename, "w") do |file|
      self.each do |k,v|
        file.write(k.to_s + "\t" + v.to_s + "\n")
      end
    end
  end
end
