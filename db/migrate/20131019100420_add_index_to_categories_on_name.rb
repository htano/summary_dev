class AddIndexToCategoriesOnName < ActiveRecord::Migration
  def change
    add_index(:categories,
              [:name],
              :name => "idx_categories_on_name",
              :unique => true)
  end
end
