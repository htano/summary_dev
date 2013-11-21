require "csv"
require "yaml"

hash = {}
csv = CSV.read("categories.csv", headers: :first_row)
id = 0;
csv.each do |row|
  id = id + 1
  hash["articles_#{id}"] = {
    "id" => id,
    "name" => row["name"],
    "created_at" => row["created_at"],
    "updated_at" => row["updated_at"]
  }
end

File.open("categories.yml", "w") { |f| f.write(hash.to_yaml) }
