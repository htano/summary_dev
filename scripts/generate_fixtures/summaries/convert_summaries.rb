require "csv"
require "yaml"

hash = {}
csv = CSV.read("summaries.csv", headers: :first_row)
id = 0;
csv.each do |row|
  id = id + 1
  hash["summaries_#{id}"] = {
    "id" => id,
    "content" => row["content"],
    "user_id" => row["user_id"].to_i,
    "article_id" => row["article_id"].to_i - 130,
    "created_at" => row["created_at"],
    "updated_at" => row["updated_at"]
  }
end

File.open("summaries.yml", "w") { |f| f.write(hash.to_yaml) }
