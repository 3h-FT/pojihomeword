require 'rails_helper'

RSpec.describe 'AiMessages', type: :system do
  let(:user) { create(:user) }
  let!(:post_favorite) { create(:post_favorite, user: user) }
  let(:target) { create(:target) }
  let(:situation) { create(:situation) }

  describe 'メッセージの作成' do
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit '/ai_messages/new'
        Capybara.assert_current_path("/users/sign_in", ignore_query: true)
        expect(current_path).to eq('/users/sign_in'), 'ログインページにリダイレクトされていません'
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end

    context 'ログインしている場合' do
      it 'Topページのリンクから遷移できる' do
        login_as(user)
        visit '/'
        click_on 'ポジティブワードを知る'
        Capybara.assert_current_path("/ai_messages/new", ignore_query: true)
        expect(current_path).to eq('/ai_messages/new')
      end

      it '正しいタイトルが表示されていること' do
        login_as(user)
        visit '/'
        click_on 'ポジティブワードを知る'
        expect(page).to have_title("ワード生成 | ポジほめワード")
      end

      it 'メッセージの作成' do
        login_as(user)
        visit '/ai_messages/new'
        fill_in '誰に送りますか', with: '自分自身'
        fill_in 'どんな時', with: '自分の成功を祝う'
        click_on 'ワードを作る'
        expect(page).to have_content('ポジティブワード生成結果')
      end
    end  

    describe 'メッセージの編集・気に入り登録解除' do
      context 'メッセージの編集・お気に入り登録解除' do
        let!(:positive_word) { create(:positive_word, user: user, word: '編集ワード') }
        
        it '作成されたメッセージの編集が可能' do
          login_as(user)
          visit "/ai_messages/#{positive_word.id}/edit"
          fill_in 'ポジティブワード', with: '編集ワード'
          click_button '更新'

          Capybara.assert_current_path("/ai_messages/new", ignore_query: true)
          expect(page).to have_text('ワードを編集しました')
          expect(page).to have_content('編集ワード')
        end

        it 'お気に入り登録・解除ができること' do
          login_as(user)
          visit '/ai_messages/new'
          fill_in '誰に送りますか', with: '自分自身'
          fill_in 'どんな時', with: '自分の成功を祝う'
          click_on 'ワードを作る'

          expect(page).to have_content('ポジティブワード生成結果')

          new_word = PositiveWord.order(created_at: :desc).first

          expect(page).to have_selector("#bookmark-button-for-word-#{new_word.id}")
          find(:css, "#bookmark-button-for-word-#{new_word.id} a").click
        end
      end  
    end    
  end    
end
