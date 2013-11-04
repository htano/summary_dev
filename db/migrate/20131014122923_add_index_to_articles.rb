class AddIndexToArticles < ActiveRecord::Migration
  def change
    add_index(:articles, 
              [:url], 
              :name => "idx_articles_on_url", 
              :unique => true)
  end
end
