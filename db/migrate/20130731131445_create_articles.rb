class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :url, :unique => true
      t.string :title
      t.integer :category_id

      t.timestamps
    end
  end
end
