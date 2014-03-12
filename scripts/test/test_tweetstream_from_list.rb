require 'tweetstream'
 
# Consumer key, Secretの設定
CONSUMER_KEY     = ENV['TWITTER_CONSUMER_KEY']
CONSUMER_SECRET  = ENV['TWITTER_CONSUMER_SECRET']
# Access Token Key, Secretの設定
ACCESS_TOKEN_KEY = ENV['TWITTER_ACCESS_TOKEN_KEY']
ACCESS_SECRET    = ENV['TWITTER_ACCESS_SECRET']

TOUCHE_FILE = "#{Rails.root}/tmp/test_tweetstream.ongoing"
DOMAIN_RANKING_FILE = "#{Rails.root}/tmp/domains-top50.txt"

# 設定
TweetStream.configure do |config|
  config.consumer_key       = CONSUMER_KEY
  config.consumer_secret    = CONSUMER_SECRET
  config.oauth_token        = ACCESS_TOKEN_KEY
  config.oauth_token_secret = ACCESS_SECRET
  config.auth_method        = :oauth
end

domains = []
open(DOMAIN_RANKING_FILE) do |f|
  f.each do |line|
    line.chomp!
    line.gsub!(/\./, " ")
    domains.push(line)
  end
end

FileUtils.touch(TOUCHE_FILE)
#TweetStream::Client.new.sample do |status|
TweetStream::Client.new.track(domains) do |status|
  unless File.exist?(TOUCHE_FILE)
    break
  end
  if status.user.lang == 'ja' &&
#    !status.text.index("RT") &&
    status.text =~ %r|http://t\.co/(.{10})| &&
    status.urls && status.urls.size > 0
    uname = status.user.screen_name
    tco_id = $1
    tco_url = "http://t.co/#{$1}"
    ex_url = status.urls[0].expanded_url
    #puts "#{uname}\t#{tco_id}\t#{tco_url}\t#{ex_url}"
    puts "#{uname}\t#{ex_url}"
  end
end
