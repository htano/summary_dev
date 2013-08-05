class CreateS010Summaries < ActiveRecord::Migration
  def change
    create_table :s010_summaries do |t|
      t.integer :summary_id, :unique => true
      t.text :summary_content
      t.integer :u010_user_id
      t.integer :article_id

      t.timestamps
    end
  end
end
