class ChangeArticlesUserArticlesCountDefault < ActiveRecord::Migration
  def change
    change_column :articles, :user_articles_count, :integer, :default => 0
  end
end
