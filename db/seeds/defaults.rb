module Seed
  @initial_users_count   = 6
  @initial_records_count = 30
  @initial_sources = %w(Other LinkedIn Glassdoor StackOverflow GitHub
                        Dice Indeed AngelList Craigslist Hired SimplyHired
                        Beyond HackerNews)
  @initial_categories = %w(Advertising Agency Automotive Communications
                           Construction Education Finance Food Gaming
                           Government Health Hospitality
                           Industrial Insurance Legal Media Music Non-Profit
                           Real-Estate Retail Search Security Science Software
                           Transportation Web)
  @default_provider = 'developer'
  @default_password = 'password'
  @default_user = { name: 'Foo Bar', email: 'foobar@example.com' }

  class << self
    # number of users (including yourself) to start out
    attr_reader :initial_users_count
    # number of companies, contacts & notes to start out
    attr_accessor :initial_records_count
    attr_accessor :initial_sources
    attr_accessor :initial_categories
    attr_accessor :default_provider
    attr_accessor :default_password
    attr_reader   :default_user
  end
end
