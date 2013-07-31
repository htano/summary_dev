class CreateS011GoodSummaries < ActiveRecord::Migration
  def change
    create_table :s011_good_summaries do |t|
      t.integer :user_id
      t.integer :summary_id

      t.timestamps
    end
  end
end
