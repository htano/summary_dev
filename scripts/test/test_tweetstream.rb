require 'tweetstream'
 
# Consumer key, Secretの設定
CONSUMER_KEY     = ENV['TWITTER_CONSUMER_KEY']
CONSUMER_SECRET  = ENV['TWITTER_CONSUMER_SECRET']
# Access Token Key, Secretの設定
ACCESS_TOKEN_KEY = ENV['TWITTER_ACCESS_TOKEN_KEY']
ACCESS_SECRET    = ENV['TWITTER_ACCESS_SECRET']
 
# 設定
TweetStream.configure do |config|
  config.consumer_key       = CONSUMER_KEY
  config.consumer_secret    = CONSUMER_SECRET
  config.oauth_token        = ACCESS_TOKEN_KEY
  config.oauth_token_secret = ACCESS_SECRET
  config.auth_method        = :oauth
end

domains = [
#  'blog livedoor jp',
#  'himasoku com',
#  'matome naver jp',
#  'alfalfalfa com',
  'news mynavi jp',
  'news nicovideo jp',
#  'irorio jp',
  'www men-joy jp',
  'jp reuters com',
  'www3 nhk or jp',
  'mainichi jp',
  'www cnn co jp',
  'www newsweekjapan jp',
  'www j-cast com',
#  'headlines yahoo co jp',
#  'zasshi news yahoo co jp',
  'www yomiuri co jp',
  'www nikkei com',
#  'sankei jp msn com',
  'jp techcrunch com',
  'www gizmodo jp',
  'www itmedia co jp',
]

count = 0
#TweetStream::Client.new.sample do |status|
TweetStream::Client.new.track(domains) do |status|
  if count > 100000
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
    count += 1
  end
end
