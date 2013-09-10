class AddFavoriteFlgToUserArticles < ActiveRecord::Migration
  def change
    add_column :user_articles, :favorite_flg, :boolean
  end
end
