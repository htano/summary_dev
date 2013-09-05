class Addindex < ActiveRecord::Migration
  def change
  	add_index(:summaries, [:user_id, :article_id], :unique => true)
  	add_index(:user_articles, [:user_id, :article_id], :unique => true)
  end
end
