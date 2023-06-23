# frozen_string_literal: true

# Initiate Code Coverage as early as possible
require 'simplecov'
SimpleCov.start

# Load twitter-research gem
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "twitter_research"
require "twitter_research/database"

require "faker"
require "factory_bot"
require "vcr"

TwitterResearch.configure! File.join(__dir__, 'fixtures', 'config.yml')

# Configure web-request recorder
VCR.configure do |c|
  # c.debug_logger = File.open 'log/vcr.log', 'w'
  c.cassette_library_dir = "spec/fixtures/vcr"
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) { FactoryBot.find_definitions }

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
