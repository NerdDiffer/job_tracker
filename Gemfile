source 'https://rubygems.org'

gem 'rails', '4.2.5.1'
gem 'pg', '~> 0.18.4'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# semantic urls
gem 'friendly_id', '~> 5.1.0'

# front-end stuff
gem 'jquery-rails', '~> 4.0.5'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'sass-rails', '~> 5.0.4'
gem 'uglifier', '>= 2.7.2'
gem 'coffee-rails', '~> 4.1.1'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'redcarpet', '~> 3.3.4'
gem 'bootstrap-multiselect-rails', '~> 0.9.9'

# Authentication-related
gem 'bcrypt', '~> 3.1.10'
gem 'omniauth-twitter', '~> 1.2.1'
gem 'omniauth-google-oauth2', '~> 0.4.1'
gem 'omniauth-github', '~> 1.1.2'

# Use pry instead of irb when calling `$ rails console` from command line
gem 'pry-rails', '~> 0.3.4'

# auto completion
gem 'redis', '~> 3.2.2'
gem 'hiredis', '~> 0.6.1'

group :development, :test do
  gem 'byebug', '~> 8.2.2', require: false
  gem 'spring', '~> 1.6.3'

  # seed data
  gem 'faker', '~> 1.6.3', require: false

  # code climate
  gem 'codeclimate-test-reporter', '~> 0.4.8', require: nil
end

group :development do
  gem 'web-console', '~> 2.3.0'
end

group :test do
  gem 'rspec-rails', '~> 3.4.2'
  gem 'factory_girl_rails', '~> 4.6.0'
end

group :production do
  # serve static assets & produce logs
  # needed b/c Rails plugin system was removed for Rails 4
  gem 'rails_12factor', '~> 0.0.3'

  # puma is better than webrick for handling incoming requests
  gem 'puma', '~> 2.12.3'
end

ruby '2.3.0'
