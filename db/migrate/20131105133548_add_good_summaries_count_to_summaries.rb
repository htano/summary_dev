class AddGoodSummariesCountToSummaries < ActiveRecord::Migration
  def change
    add_column(:summaries, 
               :good_summaries_count, 
               :integer, 
               :default => 0)
  end
end
