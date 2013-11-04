class AddSummariesConutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :summaries_count, :integer
  end
end
