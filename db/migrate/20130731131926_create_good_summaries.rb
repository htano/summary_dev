class CreateGoodSummaries < ActiveRecord::Migration
  def change
    create_table :good_summaries do |t|
      t.integer :user_id
      t.integer :summary_id

      t.timestamps
    end
  end
end
