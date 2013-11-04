class AddAutoSummaryErrorStatusToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :auto_summary_error_status, :string
  end
end
