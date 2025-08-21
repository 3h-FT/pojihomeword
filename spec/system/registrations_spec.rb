require 'rails_helper'

RSpec.describe "Registrations", type: :system do
  let(:user_attributes) { { username: "test_user", email: "test_user@example.com", password: "password123", password_confirmation: "password123" } }

  it '新規登録ページにアクセスできること' do
    visit new_user_registration_path

    expect(page).to have_content('アカウント登録')
    expect(page).to have_selector('form')
    expect(page).to have_title("アカウント登録 | ポジほめワード"), 'タイトル「新規登録 | ポジほめワード」が表示されていません'
  end

  it '新規登録が成功すること' do
    visit new_user_registration_path

    fill_in 'user_username', with: user_attributes[:username]
    fill_in 'user_email', with: user_attributes[:email]
    fill_in 'user_password', with: user_attributes[:password]
    fill_in 'user_password_confirmation', with: user_attributes[:password_confirmation]

    click_button 'アカウント登録'
    Capybara.assert_current_path("/", ignore_query: true)
    expect(page).to have_content('アカウント登録が完了しました。'), 'フラッシュメッセージ「アカウント登録が完了しました。」が表示されていません'
  end

  it 'エラーメッセージが表示されること（無効なデータで登録）' do
    visit new_user_registration_path

    fill_in 'user_username', with: ''
    fill_in 'user_email', with: ''
    fill_in 'user_password', with: '123'
    fill_in 'user_password_confirmation', with: '1234'

    click_button 'アカウント登録'
  end

  it '入力したメールアドレスがすでに登録されていた場合' do
    User.create!(username: "existing_user", email: "test_user@example.com", password: "password111", password_confirmation: "password111")

    visit new_user_registration_path

    fill_in 'user_username', with: "new_user"
    fill_in 'user_email', with: "test_user@example.com"
    fill_in 'user_password', with: "password123"
    fill_in 'user_password_confirmation', with: "password123"

    click_button 'アカウント登録'
    expect(page).to have_content("Eメールはすでに存在します"), 'フラッシュメッセージ「Eメールはすでに存在します」が表示されていません'
  end
end
