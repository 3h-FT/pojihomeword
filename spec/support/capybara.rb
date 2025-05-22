require 'selenium-webdriver'

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1680,1050')

  # SELENIUM_DRIVER_URL 環境変数を直接使用
  selenium_url = ENV.fetch('SELENIUM_DRIVER_URL', 'http://localhost:4444/wd/hub') # fallbackはローカル環境向けにlocalhostを指定
  # CI環境ではSELENTIUM_DRIVER_URLがhttp://selenium:4444/wd/hubになる想定

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: selenium_url,
    capabilities: options
  )
end