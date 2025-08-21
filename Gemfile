source "https://rubygems.org"

# ----------------------------------------
# ✅ Core Rails Components
# ----------------------------------------
gem "rails", "~> 8.0.2"
gem "pg", "~> 1.6"                      # PostgreSQL
gem "puma", ">= 5.0"                    # Webサーバ
gem "sprockets-rails"                  # アセットパイプライン
gem "importmap-rails"                  # JavaScript ESM用
gem "turbo-rails"                      # Hotwire: Turbo
gem "stimulus-rails"                   # Hotwire: Stimulus
gem "jbuilder"                         # JSONビルダー
gem "high_voltage"                     # Staticページルーティング
gem "kaminari"                         # ページネーション

# ----------------------------------------
# ✅ 認証・認可
# ----------------------------------------
gem "devise"
gem "devise-i18n"
gem "omniauth-line"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"

# ----------------------------------------
# ✅ インフラ・運用補助
# ----------------------------------------
gem "bootsnap", require: false         # 起動時間短縮
gem "dotenv-rails"                     # 環境変数管理
gem "dockerfile-rails", ">= 1.7", group: :development

# ----------------------------------------
# ✅ エラートラッキング・監視
# ----------------------------------------
gem "sentry-ruby"
gem "sentry-rails"

# ----------------------------------------
# ✅ UI / フロントエンド
# ----------------------------------------
gem "tailwindcss-ruby", "4.1.12"
gem "tailwindcss-rails"
gem "mini_magick"                      # 画像加工
gem "meta-tags", require: 'meta_tags' # OGPなどのメタ設定

# ----------------------------------------
# ✅ OpenAI / GPT連携
# ----------------------------------------
gem "ruby-openai"

# ----------------------------------------
# ✅ 検索・フィルター
# ----------------------------------------
gem "ransack", "4.3.0"

# ----------------------------------------
# ✅ その他ユーティリティ
# ----------------------------------------
gem "pry"                              # コンソール用
gem 'net-imap', '>= 0.5.7'             # メール受信処理向け

# ----------------------------------------
# ✅ 多言語対応
# ----------------------------------------
gem "rails-i18n"

# ----------------------------------------
# ✅ 開発・テスト共通
# ----------------------------------------
group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false

  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "letter_opener_web", "~> 2.0"
  gem "config"                         # 環境設定 (config/settings.yml)
end

# ----------------------------------------
# ✅ 開発専用
# ----------------------------------------
group :development do
  gem "web-console"
  gem "better_errors"
  gem "binding_of_caller"
end

# ----------------------------------------
# ✅ テスト専用
# ----------------------------------------
group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# ----------------------------------------
# ✅ Windows・JRuby向け (tzデータ補完)
# ----------------------------------------
gem "tzinfo-data", platforms: %i[windows jruby]
