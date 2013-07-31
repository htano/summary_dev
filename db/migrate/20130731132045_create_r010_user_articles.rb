class CreateR010UserArticles < ActiveRecord::Migration
  def change
    create_table :r010_user_articles do |t|
      t.integer :user_id
      t.integer :article_id
      t.boolean :read_flg

      t.timestamps
    end
  end
end
