# coding: utf-8
class Hash
  def write_dict(filename)
    open(filename, "w") do |file|
      self.each do |k,v|
        file.write(k.to_s + "\t" + v.to_s + "\n")
      end
    end
  end

  def read_kv(filename)
    open(filename) do |file|
      file.each do |line|
        line.chomp!
        k,v = line.split("\t")
        self[k] = v.to_f
      end
    end
  end

  def read_name_id(filename)
    open(filename) do |file|
      file.each do |line|
        line.chomp!
        name, id = line.split("\t")
        self[id.to_i] = name
      end
    end
  end

end
