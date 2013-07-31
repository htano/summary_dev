class CreateA010Articles < ActiveRecord::Migration
  def change
    create_table :a010_articles do |t|
      t.integer :article_id, :unique => true
      t.string :article_url, :unique => true
      t.string :article_title
      t.integer :category_id

      t.timestamps
    end
  end
end
