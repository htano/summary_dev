class AddSummariesConutToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :summaries_count, :integer
  end
end
