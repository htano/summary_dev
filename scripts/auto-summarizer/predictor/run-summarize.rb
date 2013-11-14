# encoding: utf-8
require './lib/auto-summary.rb'
include AutoSummary
PARAMS_DIR = Rails.root.to_s + "/lib/auto-summary/params"
DF_DIR = Rails.root.to_s + "/lib/text-analyzer/df_dict"

summarizer = Summarizer.new(PARAMS_DIR, DF_DIR)
Article.all.each do |e|
  user = User.find_by_name("system001")
  if user
    if e.summaries.find_by_user_id(user.id)
      Rails.logger.debug(
        "Auto summary has aleady existed.: " + e.id.to_s
      )
      next
    elsif e.auto_summary_error_status
      Rails.logger.info(
        "This page has invalid status: " + 
        e.auto_summary_error_status + 
        ", ArticleId: " + e.id.to_s
      )
      next
    end
  else
    Rails.logger.error("system001 is not exists.")
    break
  end

  summary_contents = summarizer.run(e.url)

  Summary.create(
    :content => summary_contents, 
    :user_id => user.id, 
    :article_id => e.id
  )
  puts "[URL] " + e.url
  puts "[Title] " + e.title
  puts summary_contents
  puts "\n"
end
