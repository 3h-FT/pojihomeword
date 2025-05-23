require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rspec'

# capybara等ファイルの読み込み設定
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]
  config.include FactoryBot::Syntax::Methods
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include LoginMacros
  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # Capybara設定: リモートのChromeブラウザを使用するように設定
  config.before(:each, type: :system) do
    driven_by :remote_chrome  # :remote_chrome ドライバを使用
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)  # サーバーのホスト名を取得
    Capybara.server_port = 4444  # ポート番号
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"  # アプリケーションのホストを設定
    Capybara.ignore_hidden_elements = false  # 非表示要素も無視しない
  end
end
