class AddThumbnailToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :thumbnail, :string
  end
end
