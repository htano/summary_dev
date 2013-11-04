class AddClusterVectorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cluster_vector, :text
  end
end
