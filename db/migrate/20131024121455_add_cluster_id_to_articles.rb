class AddClusterIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :cluster_id, :integer, default: 0
  end
end
