Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  #provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  #provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :github, 'd9ace621056b74fd7882', 'c51ae94cd901abcebeeb9140ffddc068fa25da54'
  provider :twitter, 'KyySEEUVeybRoV31R8tFrg', 'jcNrySLZOfMAQhix70Ivtc9zziItuoj6m4mI2JCn9gY'
  provider :facebook, '288664691272998', '8e5c104f092b178e5d3d199b917b440b'
end
