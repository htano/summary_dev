class ChangeArticlesSummariesCountDefault < ActiveRecord::Migration
  def change
    change_column :articles, :summaries_count, :integer, :default => 0
  end
end
