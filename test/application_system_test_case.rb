require "test_helper"
require "support/capybara"
require "support/helpers/capybara_custom_assertions"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :chrome

  include CapybaraCustomAssertions

  def setup
    super
    Capybara.disable_animation = true
    Capybara.server_host = "0.0.0.0"
    Capybara.app_host = app_host
    Capybara.default_driver = :chrome
    Capybara.javascript_driver = :chrome
  end
end
