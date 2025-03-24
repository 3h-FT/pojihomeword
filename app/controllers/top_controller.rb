class TopController < ApplicationController
  def index
    Rails.logger.info "✅ TopController#index に到達しました"
    render :index
  end
end
