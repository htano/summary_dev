class CreateUserArticleTags < ActiveRecord::Migration
  def change
    create_table :user_article_tags do |t|
      t.integer :user_article_id
      t.string :tag

      t.timestamps
    end
    add_index(:user_article_tags, [:user_article_id, :tag], :unique => true)
  end
end
