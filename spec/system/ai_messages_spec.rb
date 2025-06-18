require 'rails_helper'

RSpec.describe 'AiMessages', type: :system do
  let(:user) { create(:user) }

  describe 'メッセージの作成' do
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit '/ai_messages/new'
        expect(current_path).to eq('/users/sign_in'), 'ログインページにリダイレクトされていません'
        expect(page).to have_content('ログインもしくはアカウント登録してください。'), 'フラッシュメッセージが表示されていません'
      end
    end

    context 'ログインしている場合' do
      before { login_as(user) }

      it 'Topページのリンクから遷移できる' do
        visit '/'
        click_on 'ポジティブワードを知る'
        Capybara.assert_current_path("/ai_messages/new")        
        expect(current_path).to eq('/ai_messages/new'), 'Topページのリンクからポジティブワードを知るに遷移できません'
      end

      it '正しいタイトルが表示されていること' do
        visit '/'
        click_on 'ポジティブワードを知る'
        expect(page).to have_title('ワード生成 | ポジほめワード'), 'タイトル「ワード生成 | ポジほめワード」が正しく表示されていません'
      end
    end
  end

  describe 'メッセージの編集' do
    let!(:positive_word) { create(:positive_word, user: user, word: '編集ワード') }

    before { login_as(user) }

    it '作成されたメッセージの編集が可能' do
      visit "/ai_messages/#{positive_word.id}"
      click_on '編集'
      fill_in 'ワードの編集', with: '変更後ワード'
      click_button '更新'
    
      expect(current_path).to eq("/ai_messages/#{positive_word.id}")
      expect(page).to have_content('変更後ワード'), '編集内容が反映されていません'
    end
  end
end
