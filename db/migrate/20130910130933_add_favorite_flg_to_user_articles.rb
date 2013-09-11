class AddFavoriteFlgToUserArticles < ActiveRecord::Migration
  def change
    add_column :user_articles, :favorite_flg, :boolean, {:default => false} 
    change_column_default :user_articles, :read_flg, :default => false
  end
end
