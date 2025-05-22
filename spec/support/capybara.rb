require 'selenium-webdriver'

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1680,1050')

  selenium_url = ENV.fetch('SELENIUM_DRIVER_URL') {
    # fallback ロジックを用意
    if ENV['GITHUB_ACTIONS'] == 'true'
      'http://selenium:4444/wd/hub'
    else
      'http://selenium-hub:4444/wd/hub'
    end
  }

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: selenium_url,
    capabilities: options
  )
end
