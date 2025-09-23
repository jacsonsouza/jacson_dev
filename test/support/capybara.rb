def chrome_options
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--no-default-browser-check")
  options.add_argument("--start-maximized")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1366,768")
  options.add_argument("--headless") unless ENV["LAUNCH_BROWSER"]
  options
end

def app_host
  app = "http://#{ENV.fetch('TEST_APP_HOST', nil)}"
  port = Capybara.server_port
  "#{app}:#{port}"
end

Capybara.register_driver :chrome do |app|
  host = "http://#{ENV.fetch('SELENIUM_HOST', nil)}"
  port = ENV.fetch("SELENIUM_PORT", nil)

  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: "#{host}:#{port}/wd/hub",
                                 options: chrome_options)
end

# Necessary to correct working of screenshot
Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end
