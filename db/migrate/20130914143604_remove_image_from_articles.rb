class RemoveImageFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :image, :binary
  end
end
