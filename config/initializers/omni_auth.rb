OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
           ENV['TWITTER_KEY'],
           ENV['TWITTER_SECRET']
  provider :github,
           ENV['GITHUB_KEY'],
           ENV['GITHUB_SECRET']
  provider :google_oauth2,
           ENV['GOOGLE_CLIENT_ID'],
           ENV['GOOGLE_CLIENT_SECRET'],
           scope: 'profile',
           name:  'google'
end

OmniAuth.config.on_failure = proc do |env|
  failure = Sessions::OmniAuthUsersController.action(:failure)
  failure.call(env)
end
