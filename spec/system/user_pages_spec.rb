require 'rails_helper'

RSpec.describe "UserPages", type: :system do
  let(:user) { create(:user) }

  describe 'ユーザーページ一覧' do
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる', js: true do
        visit '/userpages'
        Capybara.assert_current_path("/users/sign_in", ignore_query: true)
        expect(current_path).to eq('/users/sign_in')
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end

    context 'ログインしている場合' do
      before { login_as(user) }

      it 'Topページのリンクから遷移できる', js: true do
        visit '/'
        click_on 'ポジティブワードをためる'
        Capybara.assert_current_path("/userpages", ignore_query: true)
        expect(current_path).to eq('/userpages')
      end

      it 'ページタイトルが表示される', js: true do
        visit '/userpages'
        expect(page).to have_title('ユーザーページ | ポジほめワード')
      end
    end
  end

  describe '「すべて」タブ' do
    before { login_as(user) }

    context 'ワードがない場合' do
      it '何もない旨のメッセージが表示される', js: true do
        visit '/userpages?tab=all'
        expect(page).to have_selector("[data-tab-content='all']", visible: true)
        expect(page).to have_content('登録されたワードはありません')
      end
    end

    context 'カスタムワードを作成する' do
      it '作成後に表示される', js: true do
        visit '/userpages'
        find("[data-tab='all']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='all']", visible: true)

        within '[data-tab-content="all"]' do
          fill_in 'ワードを入力', with: 'カスタムワード'
          click_button '追加'
          expect(page).to have_content('カスタムワード')
        end
      end
    end
  end

  describe '「カスタム」タブ' do
    before { login_as(user) }

    context 'ワードがない場合' do
      it 'メッセージが表示される', js: true do
        visit '/userpages?tab=custom'
        find("[data-tab='custom']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='custom']", visible: true)
        expect(page).to have_content('カスタムワードはありません')
      end
    end

    context 'カスタムワードが10件以下の場合' do
      before { create_list(:positive_word, 10, user: user, is_custom: true) }

      it 'ページングが表示されない', js: true do
        visit '/userpages?tab=custom'
        find("[data-tab='custom']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='custom']", visible: true)

        within "[data-tab-content='custom']" do
          expect(page).not_to have_selector('.pagination')
        end
      end
    end

    context 'カスタムワードが11件以上ある場合' do
      before { create_list(:positive_word, 11, user: user, is_custom: true) }

      it 'ページングが表示される', js: true do
        visit '/userpages?tab=custom'
        find("[data-tab='custom']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='custom']", visible: true)

        within "[data-tab-content='custom']" do
          expect(page).to have_selector('.pagination')
        end
      end
    end

    context 'カスタムワードの編集・削除' do
      let!(:positive_word) { create(:positive_word, user: user, word: '削除対象', is_custom: true) }

      it 'カスタムワードが編集できること', js: true do
        visit '/userpages?tab=custom'
        find("[data-tab='custom']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='custom']", visible: true)

        within("[data-tab-content='custom']") do
          find("[data-testid='edit-button-#{positive_word.id}']", wait: 5).click
        end

        visit "/userpages/#{positive_word.id}/edit"
        fill_in 'ポジティブワード', with: '編集カスタムワード'
        click_button '更新'

        Capybara.assert_current_path("/userpages", ignore_query: true)
        expect(current_path).to eq('/userpages')
        expect(page).to have_text('カスタムワードを編集しました')
        expect(page).to have_content('編集カスタムワード')
      end

      it 'カスタムワードが削除できること', js: true do
        visit '/userpages?tab=custom'
        find("[data-tab='custom']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='custom']", visible: true)

        within("[data-tab-content='custom']") do
          find("[data-testid='delete-button-#{positive_word.id}']", wait: 5).click
        end

        expect(page).to have_text('ワードを削除しました')
        expect(page).not_to have_content('削除対象')
      end
    end
  end

  describe '「お気に入り」タブ' do
    before { login_as(user) }

    context 'ワードがない場合' do
      it 'メッセージが表示される', js: true do
        visit '/userpages?tab=favorite'
        find("[data-tab='favorite']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='favorite']", visible: true)
        expect(page).to have_content('お気に入り登録はありません')
      end
    end

    context 'ワードがある場合' do
      let!(:positive_word) { create(:positive_word, user: user, situation: create(:situation), target: create(:target)) }
      let!(:word_favorite) { create(:word_favorite, user: user, positive_word: positive_word) }

      it '表示される', js: true do
        visit '/userpages?tab=favorite'
        find("[data-tab='favorite']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='favorite']", visible: true)

        within "[data-tab-content='favorite']" do
          expect(page).to have_content(positive_word.word)
        end
      end
    end

    context 'ワードが11件以上ある場合' do
      before { create_list(:word_favorite, 11, user: user) }

      it 'ページングが表示される', js: true do
        visit '/userpages?tab=favorite'
        find("[data-tab='favorite']", wait: 5).click
        expect(page).to have_selector("[data-tab-content='favorite']", visible: true)
        within "[data-tab-content='favorite']" do
          expect(page).to have_selector('.pagination')
        end
      end
    end
  end
end
