source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'pg', '~> 0.18.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# semantic urls
gem 'friendly_id', '~> 5.1.0'

# front-end stuff
gem 'jquery-rails', '~> 4.0.4'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'redcarpet', '~> 3.3.2'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use pry instead of irb when calling `$ rails console` from command line
gem 'pry-rails', '~> 0.3.4'

# auto completion
gem 'redis', '~> 3.2.1'
gem 'hiredis', '~> 0.6.0'

group :development, :test do
  gem 'byebug', '~> 8.2.2', require: false
  gem 'web-console', '~> 2.0'
  gem 'spring', '~> 1.3.6'
  gem 'rspec-rails', '~>3.0'
  gem 'factory_girl_rails', '~> 1.2'

  # seed data
  gem 'faker', '~> 1.4.3'

  # code climate
  gem 'codeclimate-test-reporter', '~> 0.4.8', require: nil
end

group :production do
  # serve static assets & produce logs
  # needed b/c Rails plugin system was removed for Rails 4
  gem 'rails_12factor', '~> 0.0.3'

  # puma is better than webrick for handling incoming requests
  gem 'puma', '~> 2.12.2'
end

ruby '2.2.3'
