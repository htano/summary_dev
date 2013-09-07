class AddStrengthToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :strength, :decimal, :default => nil
    add_column :articles, :last_added_at, :datetime, :default => nil
    add_index :articles, [:last_added_at, :strength], :name => 'idx_strength'
  end
end
