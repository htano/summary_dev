class AddIndexToGoodSummariesOnUserIdAndSummaryId < ActiveRecord::Migration
  def change
    add_index(:good_summaries,
              [:user_id, :summary_id],
              :name => "idx_good_summaries_on_user_id_and_summary_id",
              :unique => true)
  end
end
