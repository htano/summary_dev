Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  #provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  #provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  case Rails.env
  when "production"
    provider :github, 'b16b5df37a08012a8628', '694ad0452d4cf885ddd2001fd6c9d7ecbf4903a9'
    provider :twitter, 'gEtGqvsShBhvYwJ0PT5ryw', 'eqKksK5TBqxXMx5nfToZM409bAoUJ8IBaM6OjIplas'
    provider :facebook, '612232268799464', 'ba6a387f5cf918f2fc43baf69c213bd5'
  when "development"
    provider :github, 'd9ace621056b74fd7882', 'c51ae94cd901abcebeeb9140ffddc068fa25da54'
    provider :twitter, 'KyySEEUVeybRoV31R8tFrg', 'jcNrySLZOfMAQhix70Ivtc9zziItuoj6m4mI2JCn9gY'
    provider :facebook, '288664691272998', '8e5c104f092b178e5d3d199b917b440b'
  else
  end
end
