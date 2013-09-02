class CreateUserArticles < ActiveRecord::Migration
  def change
    create_table :user_articles do |t|
      t.integer :user_id
      t.integer :article_id
      t.boolean :read_flg


      t.timestamps
    end
    add_index(:user_articles, [:user_id, :article_id], :unique => true)
  end
end
