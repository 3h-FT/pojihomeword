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
          find('[data-testid="menu-toggle"]').click
          expect(page).to have_selector("a[href='/userpages/#{positive_word.id}/edit']", wait: 5)
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
        expect(page).to have_selector("[data-tab-content='custom']", visible: true)

        within("[data-tab-content='custom']") do
          find('[data-testid="menu-toggle"]', wait: 5).click
          find("button", text: '削除', wait: 5).click
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
        visit userpages_path(tab: 'favorite')
        find("[data-tab='favorite']", wait: 5).click
        expect(page).to have_content('お気に入り登録はありません')
      end
    end

    context 'ワードがある場合' do
      it 'AIメッセージを生成してお気に入りに登録し、favoriteタブで表示される' do
        visit new_ai_message_path

        fill_in '誰に送りますか', with: '友達'
        fill_in 'どんな時', with: '励ましたい時'
        click_button 'ワードを作る'

        expect(page).to have_content('ポジティブワード生成結果')
        new_word = PositiveWord.order(created_at: :desc).first
        
        find('[data-testid="menu-toggle"]', wait: 5).click
        find(:css, "a[href='/word_favorites?positive_word_id=#{new_word.id}']").click


        visit userpages_path(tab: 'favorite')
        expect(page).to have_content(new_word.word)
        expect(page).not_to have_selector('.pagination'),'10件以下はページネーションが表示されない'
      end

      it '11件以上お気に入り登録したら、ページネーションされ2ページ目に11件目が表示される' do
        11.times do |i|
          word = create(:positive_word, user:, word: "お気に入り#{i + 1}")
          user.word_favorites.create!(positive_word: word)
        end

        visit userpages_path(tab: 'favorite')

        (1..10).each do |i|
          expect(page).to have_content("お気に入り#{i}")
        end
        expect(page).not_to have_content("お気に入り11")

        within "[data-tab-content='favorite']" do
          expect(page).to have_selector('.pagination')
        end
      end

      it 'お気に入り登録したワードの編集が可能' do
        login_as(user)
        word = create(:positive_word, user:, word: "編集ワード")
        user.word_favorites.create!(positive_word: word)

        visit userpages_path(tab: 'favorite')
        within "[data-tab-content='favorite']" do
          find('[data-testid="menu-toggle"]', wait: 5).click
          find("a[href='/ai_messages/#{word.id}/edit?from=userpages']").click
        end

        fill_in 'ポジティブワード', with: '編集後のワード'
        click_button '更新'

        Capybara.assert_current_path("/userpages", ignore_query: true)
        expect(page).to have_text('ワードを編集しました')
        expect(page).to have_content('編集後のワード')
      end
    end
  end
end
