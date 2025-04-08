require 'rails_helper'

RSpec.describe "Registrations", type: :system do
  let(:user_attributes) { { username: "test_user", email: "test_user@example.com", password: "password123", password_confirmation: "password123" } }

  it '新規登録ページにアクセスできること' do
    visit new_user_registration_path

    expect(page).to have_content('新規登録')
    expect(page).to have_selector('form')
  end

  it '新規登録が成功すること' do
    visit new_user_registration_path

    fill_in 'user_username', with: user_attributes[:username]
    fill_in 'user_email', with: user_attributes[:email]
    fill_in 'user_password', with: user_attributes[:password]
    fill_in 'user_password_confirmation', with: user_attributes[:password_confirmation]

    click_button '登録'
    expect(page.current_path).to eq(root_path)
  end

  it 'エラーメッセージが表示されること（無効なデータで登録）' do
    visit new_user_registration_path

    fill_in 'user_username', with: ''
    fill_in 'user_email', with: 'invalid-email'
    fill_in 'user_password', with: '123'
    fill_in 'user_password_confirmation', with: '1234'

    click_button '登録'
  end
end
