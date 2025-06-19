require 'rails_helper'

RSpec.describe "UserPages", type: :system do
  let(:user) { create(:user) }

  describe 'ユーザーページ一覧' do
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        visit '/userpages'
        expect(current_path).to eq('/users/sign_in'), 'ログインページにリダイレクトされません'
        expect(page).to have_content('ログインもしくはアカウント登録してください。'), 'フラッシュメッセージ「ログインもしくはアカウント登録してください。」が表示されていません'
      end
    end

    context 'ログインしている場合' do
      before { login_as(user) }

      it 'Topページのリンクから遷移できる' do
        visit '/'
        click_on 'ポジティブワードをためる'
        Capybara.assert_current_path("/userpages")         
        expect(current_path).to eq('/userpages'), 'Topページのリンクからポジティブワードをためるに遷移できません'
      end

      it 'ページタイトルが表示される' do
        visit '/userpages'
        expect(page).to have_title('ユーザーページ | ポジほめワード'), 'タイトル「新規登録 | ポジほめワード」が表示されていません'
      end
    end
  end

  describe '「すべて」タブ' do
    before { login_as(user) }

    context 'ワードがない場合' do
      it '何もない旨のメッセージが表示される' do
        visit '/userpages?filter=all'
        expect(page).to have_content('ワードがありません'), 'ページ内に「ワードはありません」が表示されていません'
      end
    end

    context 'カスタムワードを作成する' do
      it '作成後に表示される' do
        visit '/userpages?filter=custom'
        click_link '作成'
        fill_in 'カスタムワードの追加', with: 'カスタムワード'
        click_button '追加'
        expect(page).to have_content('ワードを追加しました'), 'フラッシュメッセージ「ワードを追加しました」が表示されていません'
        expect(page).to have_content('カスタムワード'), 'ページ内に「カスタムワード」が表示されていません'
      end
    end
  end

  describe '「カスタム」タブ' do
    before { login_as(user) }

    context 'ワードがない場合' do
      it 'メッセージが表示される' do
        visit '/userpages?filter=custom'
        expect(page).to have_content('ワードがありません'), 'ページ内に「ワードはありません」が表示されていません'
      end
    end

    context 'カスタムワードの編集・削除' do
      let!(:positive_word) { create(:positive_word, user: user, word: '削除対象', is_custom: true) }

      it '編集できる' do
        visit '/userpages?filter=custom'
        find('[data-testid="menu-toggle"]', match: :first).click
        click_link '編集'

        fill_in 'ワードの編集', with: '変更後ワード'
        click_button '更新'
        expect(page).to have_content('変更後ワード'), 'ページ内に「変更後ワード」が表示されていません'
      end

      it '削除できる' do
        visit '/userpages?filter=custom'
        find('[data-testid="menu-toggle"]', match: :first).click
        accept_confirm do
          click_link '削除'
        end
        expect(page).not_to have_content('削除対象'), 'ページ内に「削除対象」が表示されています'
      end
    end
  end

  describe '「お気に入り」タブ' do
    before { login_as(user) }

    context 'ワードがない場合' do
      it 'メッセージが表示される' do
        visit '/userpages?filter=favorite'
        expect(page).to have_content('ワードがありません'), 'ページ内に「ワードはありません」が表示されていません'
      end
    end

    context 'お気に入り解除できる' do
      let!(:positive_word) { create(:positive_word, user: user, word: 'お気に入りワード') }

      before do
        create(:word_favorite, user: user, positive_word: positive_word)
      end

      it 'お気に入り解除後に表示されない' do
        visit '/userpages?filter=favorite'

        expect(page).to have_content('お気に入りワード'), 'お気に入りワードが表示されていません'

        find('[data-testid="menu-toggle"]', match: :first).click
        within "#bookmark-button-for-word-#{positive_word.id}" do
          expect(page).to have_link('いいね', wait: 10)
          find('a', text: 'いいね', wait: 10).click
        end
        
        expect(page).to have_content('お気に入りワード', wait: 10), 'いいね解除直後に非表示になるべきではありません'        
        
        visit '/userpages?filter=all'
        expect(page).not_to have_content('お気に入りワード'), 'お気に入り解除後もワードが表示されています'
      end
    end
  end
end
