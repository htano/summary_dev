require "csv"
require "yaml"

hash = {}
csv = CSV.read("user_article_tags.csv", headers: :first_row)
id = 0;
csv.each do |row|
  id = id + 1
  user_article_id = row["user_article_id"].to_i
  if user_article_id >= 300
    user_article_id = user_article_id - 299
  elsif user_article_id >= 200 && user_article_id < 300
    user_article_id = user_article_id - 199
  elsif user_article_id >= 100 && user_article_id < 200
    user_article_id = user_article_id - 99
  else
  end

  hash["tags_#{id}"] = {
    "id" => id,
    "user_article_id" => user_article_id,
    "tag" => row["tag"],
    "created_at" => row["created_at"],
    "updated_at" => row["updated_at"]
  }
end

File.open("user_article_tags.yml", "w") { |f| f.write(hash.to_yaml) }
