class AddUniqueIndexToSummaries < ActiveRecord::Migration
  def change
  	add_index(:summaries, [:user_id, :article_id], :unique => true)
  end
end
