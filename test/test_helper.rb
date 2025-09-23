require "support/simplecov"
require "support/bullet"
require "support/helpers/integration_custom_assertions"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    include BulletHelper
    include IntegrationCustomAssertions
    include Devise::Test::IntegrationHelpers

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}" if ENV["COVERAGE"]
    end

    parallelize_teardown do |_worker|
      SimpleCov.result if ENV["COVERAGE"]
    end
  end
end
