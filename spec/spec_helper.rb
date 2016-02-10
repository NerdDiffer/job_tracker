require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
SimpleCov.start do
  add_filter '/config'
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing non-existing method on real objects.
    mocks.verify_partial_doubles = true
  end

  # Allow more verbose output when running an individual spec file.
  config.default_formatter = 'doc' if config.files_to_run.one?
end
