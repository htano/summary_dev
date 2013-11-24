require "csv"
require "yaml"

hash = {}
csv = CSV.read("articles.csv", headers: :first_row)
id = 0;
csv.each do |row|
  id = id + 1
  hash["articles_#{id}"] = {
    "id" => id,
    "url" => row["url"],
    "title" => row["title"],
    "category_id" => row["category_id"].to_i,
    "created_at" => row["created_at"],
    "updated_at" => row["updated_at"],
    "strength" => row["strength"],
    "last_added_at" => row["last_added_at"],
    "contents_preview" => row["contents_preview"],
    "thumbnail" => row["thumbnail"],
    "summaries_count" => row["summaries_count"].to_i,
    "user_articles_count" => row["user_articles_count"].to_i,
    "cluster_id" => row["cluster_id"].to_i,
    "auto_summary_error_status" => row["auto_summary_error_status"]
  }
end

File.open("articles.yml", "w") { |f| f.write(hash.to_yaml) }
