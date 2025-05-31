require 'rails_helper'

RSpec.describe 'PostsPosts', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:post) { create(:post, user: user) }

  describe '投稿ワードのCRUD' do
    describe '投稿ワードの一覧' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/posts'
          Capybara.assert_current_path("/users/sign_in", ignore_query: true)
          expect(current_path).to eq('/users/sign_in'), 'ログインページにリダイレクトされていません'
          expect(page).to have_content('ログインもしくはアカウント登録してください。'), 'フラッシュメッセージ「ログインもしくはアカウント登録してください。」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        it 'Topページのリンクから遷移できる' do
          login_as(user)
          visit '/'
          click_on 'ポジティブワードを共有する'
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq('/posts')
        end

        it '正しいタイトルが表示されていること' do
          login_as(user)
          visit '/'
          click_on 'ポジティブワードを共有する'
          expect(page).to have_title("みんなのポジほめワード | ポジほめワード"), 'タイトル「みんなのポジほめワード | ポジほめワード」が表示されていません'
        end

        context '投稿ワードが一件もない場合' do
          it '何もない旨のメッセージが表示されること' do
            login_as(user)
            visit '/'
            click_on 'ポジティブワードを共有する'
            Capybara.assert_current_path("/posts", ignore_query: true)
            expect(current_path).to eq('/posts')
            expect(page).to have_content('まだ投稿はありません。'), 'ページ内に「まだ投稿はありません。」が表示されていません'
          end
        end

        context '投稿ワードがある場合' do
          it '投稿ワード一覧が表示されること' do
            post
            login_as(user)
            visit '/'
            click_on 'ポジティブワードを共有する'
            expect(page).to have_content(post.post_word), 'ページ内に「投稿ワード」が表示されていません'
            expect(page).to have_content(post.user.username), 'ページ内に「投稿者」が表示されていません'
            expect(page).to have_content(post.caption), 'ページ内に「投稿の説明」が表示されていません'
          end
        end

        context '10件以下の場合' do
          let!(:post) { create_list(:post, 10) }
          it 'ページングが表示されないこと' do
            login_as(user)
            visit '/'
            click_on 'ポジティブワードを共有する'
            expect(page).not_to have_selector('.pagination')
          end
        end

        context '11件以上ある場合' do
          let!(:post) { create_list(:post, 11) }
          it 'ページングが表示されること' do
            login_as(user)
            visit '/'
            click_on 'ポジティブワードを共有する'
            expect(page).to have_selector('.pagination')
          end
        end
      end
    end

    describe '投稿の詳細' do
      context 'ログインしていない場合' do
        it '投稿詳細が閲覧できること' do
          visit post_path(post)
          expect(page).to have_content('投稿詳細'), 'ページ内に「投稿詳細」が表示されていません'
          expect(page).to have_content(post.post_word), 'ページ内に「投稿ワード」が表示されていません'
          expect(page).to have_content(post.caption), 'ページ内に「投稿の説明」が表示されていません'
          expect(page).to have_content(post.user.username), 'ページ内に「投稿者」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        before do
          post
          login_as(user)
        end

        it '投稿詳細が表示されること' do
          visit '/'
          click_on 'ポジティブワードを共有する'
          first(:css, "#post-id-#{post.id} a", text: post.post_word).click
          Capybara.assert_current_path("/posts/#{post.id}", ignore_query: true)
          expect(current_path).to eq("/posts/#{post.id}")
          expect(page).to have_content(post.post_word), 'ページ内に「投稿ワード」が表示されていません'
          expect(page).to have_content(post.user.username), 'ページ内に「投稿者」が表示されていません'
          expect(page).to have_content(post.caption), 'ページ内に「投稿の説明」が表示されていません'
        end

        it '正しいタイトルが表示されていること' do
          visit '/'
          click_on 'ポジティブワードを共有する'
          first(:css, "#post-id-#{post.id} a", text: post.post_word).click
          expect(page).to have_title("#{post.post_word} | ポジほめワード"), 'タイトル「#{post.post_word} | ポジほめワード」が表示されていません'
        end
      end
    end

    describe '投稿の作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/posts/new'
          Capybara.assert_current_path("/users/sign_in", ignore_query: true)
          expect(current_path).to eq('/users/sign_in')
          expect(page).to have_content('ログインもしくはアカウント登録してください。'), 'フラッシュメッセージ「ログインもしくはアカウント登録してください。」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        before do
          login_as(user)
          visit '/'
          click_on 'ポジティブワードを共有する'
        end

        it '正しいタイトルが表示されていること' do
          click_on '+ 新規投稿'
          Capybara.assert_current_path("/posts/new", ignore_query: true)
          expect(current_path).to eq('/posts/new')      
          expect(page).to have_title("新規投稿 | ポジほめワード"), 'タイトル「新規投稿 | ポジほめワード」が表示されていません'
        end

        it '投稿できること' do
          click_on '+ 新規投稿'
          fill_in '投稿したいワード', with: 'テストワード'
          fill_in 'ワードの説明', with: 'テストキャプション'
          click_button '投稿'
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq('/posts')
          expect(page).to have_content('投稿しました'), 'フラッシュメッセージ「投稿しました」が表示されていません'
          expect(page).to have_content('テストワード'), 'ページ内に「テストワード」が表示されていません'
          expect(page).to have_content('テストキャプション'), 'ページ内に「テストキャプション」が表示されていません'
        end

        it '投稿に失敗すること' do          
          click_on '+ 新規投稿'
          fill_in 'ワードの説明', with: 'テストキャプション'
          click_button '投稿'
          expect(page).to have_content('投稿できません'), 'フラッシュメッセージ「投稿できません」が表示されていません'
        end
      end
    end

    describe '投稿ワードの更新' do
      before { post }

      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit edit_post_path(post)
          Capybara.assert_current_path("/users/sign_in", ignore_query: true)
          expect(current_path).to eq('/users/sign_in')
          expect(page).to have_content('ログインもしくはアカウント登録してください。'), 'フラッシュメッセージ「ログインもしくはアカウント登録してください。」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        context '自分の投稿ワード' do
          before do
            login_as(user)
            visit posts_path
            find("#button-edit-#{post.id}").click
          end

          it '投稿ワードが更新できること' do
            fill_in '投稿したいワード', with: '編集ワード'
            fill_in 'ワードの説明', with: '編集キャプション'
            click_button '投稿'
            Capybara.assert_current_path("/posts/#{post.id}", ignore_query: true)
            expect(current_path).to eq post_path(post)
            expect(page).to have_content('編集しました'), 'フラッシュメッセージ「編集しました」が表示されていません'
            expect(page).to have_content('編集ワード'), 'ページ内に「編集ワード」が表示されていません'
            expect(page).to have_content('編集キャプション'), 'ページ内に「編集キャプション」が表示されていません'
          end

          it '編集に失敗すること' do
            fill_in '投稿したいワード', with: ''
            fill_in 'ワードの説明', with: ''
            click_button '投稿'
            expect(page).to have_content('編集できません'), 'フラッシュメッセージ「編集できません」が表示されていません'
          end
        end

        context '他人の投稿' do
          it '編集ボタンが表示されないこと' do
            login_as(another_user)
            visit posts_path
            expect(page).not_to have_selector("#button-edit-#{post.id}")
          end
        end
      end
    end

    describe '投稿の削除' do
      before { post }

      context '自分の投稿' do
        it '投稿が削除できること' do
          login_as(user)
          visit '/posts'
          page.accept_confirm { find("#button-delete-#{post.id}").click }
          expect(current_path).to eq('/posts')
          expect(page).to have_content('投稿を削除しました'), 'フラッシュメッセージ「投稿を削除しました」が表示されていません'
        end
      end

      context '他人の投稿' do
        it '削除ボタンが表示されないこと' do
          login_as(another_user)
          visit posts_path
          expect(page).not_to have_selector("#button-delete-#{post.id}")
        end
      end
    end

    describe '投稿のお気に入り一覧' do
      before { post }

      context '1件もお気に入り登録していない場合' do
        it '1件もない旨のメッセージが表示されること' do
          login_as(user)
          visit posts_path
          click_on '★お気に入り'
          Capybara.assert_current_path("/posts/post_favorites", ignore_query: true)
          expect(current_path).to eq(favorites_posts_path)
          expect(page).to have_content('お気に入り登録はありません'), 'ページ内に「お気に入り登録はありません」が表示されていません'
        end
      end

      context 'ブックマークしている場合' do
        it 'ブックマークした投稿が表示されること' do
          login_as(another_user)
          visit posts_path
          find("#post-favorite-button-#{post.id}").click
          click_on '★お気に入り'
          Capybara.assert_current_path("/posts/post_favorites", ignore_query: true)
          expect(current_path).to eq(favorites_posts_path)
          expect(page).to have_content(post.post_word), 'ページ内に「お気に入り登録したワード」が表示されていません'
          expect(page).to have_content(post.caption), 'ページ内に「キャプション」が表示されていません'
          expect(page).to have_content(post.user.username), 'ページ内に「投稿者」が表示されていません'
        end
      end

      context '10件以下の場合' do
        let!(:posts) { create_list(:post, 10) }
        it 'ページングが表示されないこと' do
          posts.each { |p| PostFavorite.create(user: another_user, post: p) }
          login_as(another_user)
          visit favorites_posts_path
          expect(page).not_to have_selector('.pagination')
        end
      end

      context '11件以上ある場合' do
        let!(:posts) { create_list(:post, 11) }
        it 'ページングが表示されること' do
          posts.each { |p| PostFavorite.create(user: another_user, post: p) }
          login_as(another_user)
          visit favorites_posts_path
          expect(page).to have_selector('.pagination')
        end
      end
    end
  end
end
