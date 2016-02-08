# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing non-existing method on real objects.
    mocks.verify_partial_doubles = true
  end

  # Allow more verbose output when running an individual spec file.
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Print the 10 slowest examples and example groups at end of spec run
  config.profile_examples = 10
end
