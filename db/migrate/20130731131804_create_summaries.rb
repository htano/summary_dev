class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.text :content
      t.integer :user_id
      t.integer :article_id

      t.timestamps
    end
  end
end
