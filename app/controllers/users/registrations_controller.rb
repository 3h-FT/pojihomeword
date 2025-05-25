# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # 新規登録時にUIDを自動で割り振る（SNS認証連携のため）
  def build_resource(hash = {})
    hash[:uid] = User.create_unique_string
    super
  end

  # パスワード変更なしでユーザー情報更新を許可
  def update_resource(resource, params)
    if params['password'].present?
      super
    else
      resource.update_without_password(params.except('current_password'))
    end
  end
end
