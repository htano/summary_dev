class AddUserArticlesConutToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :user_articles_count, :integer
  end
end
