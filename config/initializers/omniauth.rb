Rails.application.config.middleware.use OmniAuth::Builder do
  provider(:github, 
           ENV['OMNIAUTH_GITHUB_KEY'], 
           ENV['OMNIAUTH_GITHUB_SECRET'])
  provider(:twitter, 
           ENV['OMNIAUTH_TWITTER_KEY'], 
           ENV['OMNIAUTH_TWITTER_SECRET'])
  provider(:facebook, 
           ENV['OMNIAUTH_FACEBOOK_KEY'], 
           ENV['OMNIAUTH_FACEBOOK_SECRET'])
end
