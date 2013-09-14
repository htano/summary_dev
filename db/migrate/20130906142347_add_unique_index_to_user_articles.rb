class AddUniqueIndexToUserArticles < ActiveRecord::Migration
  def change
  	add_index(:user_articles, [:user_id, :article_id], :unique => true)
  end
end
