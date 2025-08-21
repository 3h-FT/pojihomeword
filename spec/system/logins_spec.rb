require 'rails_helper'

RSpec.describe "ログイン機能", type: :system do
  let(:user) { create(:user) }
  
  describe '通常画面' do
    describe 'ログイン' do
      it '正しいタイトルが表示されていること' do
        visit '/users/sign_in'
        Capybara.assert_current_path("/users/sign_in", ignore_query: true)
        expect(page).to have_title("ログイン | ポジほめワード"), 'タイトル「ログイン | ポジほめワード」が表示されていません'
      end
    end
      context '認証情報が正しい場合' do
        it 'ログインできること' do
          visit '/users/sign_in'
          fill_in 'Eメール', with: user.email
          fill_in 'パスワード', with: 'password'
          click_button 'ログイン'
          Capybara.assert_current_path("/", ignore_query: true)
          expect(current_path).to eq '/'
          expect(page).to have_content('ログインしました。'), 'フラッシュメッセージ「ログインしました。」が表示されていません'
        end
      end

      context 'PWに誤りがある場合' do
        it 'ログインできないこと' do
          visit '/users/sign_in'
          fill_in 'Eメール', with: user.email
          fill_in 'パスワード', with: '1234'
          click_button 'ログイン'
          Capybara.assert_current_path("/users/sign_in", ignore_query: true)
          expect(current_path).to eq('/users/sign_in'), 'ログイン失敗時にログイン画面に戻ってきていません'
        end
      end
    end

    describe 'ログアウト' do
      before do
        login_as(user)
      end
      it 'ログアウトできること' do
        visit '/'
        find('#logout-button-desktop', match: :first).click
        Capybara.assert_current_path("/", ignore_query: true)
        expect(current_path).to eq root_path
        expect(page).to have_content('ログアウトしました。'), 'フラッシュメッセージ「ログアウトしました。」が表示されていません'
      end
    end
  end
