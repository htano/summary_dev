class AddContentsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :contents_preview, :string
  end
end
