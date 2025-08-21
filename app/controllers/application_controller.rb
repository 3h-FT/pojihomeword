class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :prepare_meta_tags

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from StandardError, with: :render_500
  
  private

  def after_sign_in_path_for(resource)
    root_path  # ここでログイン後に遷移したいパスを指定
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
  end
  # 404エラーを public/404.html に接続
  def render_404(exception = nil)
    log_error(exception)
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end

  # 500エラーを public/500.html に接続
  def render_500(exception = nil)
    log_error(exception)
    render file: Rails.public_path.join("500.html"), status: :internal_server_error, layout: false
  end

  def log_error(exception)
    if exception
      Rails.logger.error "エラー発生: #{exception.message}"
      Rails.logger.error exception.backtrace.join("\n")
      Sentry.capture_exception(exception) if defined?(Sentry)
    end
  end
end
