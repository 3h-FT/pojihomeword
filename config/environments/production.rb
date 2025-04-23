require "active_support/core_ext/integer/time"

Rails.application.configure do
  # 許可するホストを明示
  config.hosts << "graduation-project-x30c.onrender.com"

  # コードはリクエスト間でリロードされません
  config.enable_reloading = false

  # 起動時にコードをイージャーロード
  config.eager_load = true

  # エラーレポートを無効化し、キャッシュを有効に
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # 全てのアクセスをSSLに強制
  config.force_ssl = true

  # ログを標準出力に
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # ログレベル
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # I18nフォールバック
  config.i18n.fallbacks = true

  # 非推奨警告を無効化
  config.active_support.report_deprecations = false

  # マイグレーション後にスキーマをダンプしない
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.default_url_options = { host: 'graduation-project-x30c.onrender.com' }
  
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "graduation-project-x30c.onrender.com",
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
   }
end
