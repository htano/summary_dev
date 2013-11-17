# encoding: utf-8
require './lib/auto-summary.rb'
include AutoSummary

summarizer = Summarizer.new
Article.all.each do |e|
  user = User.find_by_name(AUTO_SUMMARIZER_NAME)
  if user
    if e.summaries.find_by_user_id(user.id)
      #Rails.logger.debug(
      #  "Auto summary has aleady existed.: " + e.id.to_s
      #)
      next
    elsif e.auto_summary_error_status
      #Rails.logger.info(
      #  "This page has invalid status: " + 
      #  e.auto_summary_error_status + 
      #  ", ArticleId: " + e.id.to_s
      #)
      #next
    end
  else
    Rails.logger.error("system001 is not exists.")
    break
  end

  summary_contents, error_status = summarizer.run(e.url)
  if error_status
    e.auto_summary_error_status = error_status
    e.save
  else
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

end
