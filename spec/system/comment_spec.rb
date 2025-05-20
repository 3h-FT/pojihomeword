require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let!(:comment_by_me) { create(:comment, user: user, post: post) }
  let!(:comment_by_others) { create(:comment, post: post) }

  describe 'コメント機能' do
    it 'コメントの一覧が表示されること' do
      login_as(user)
      visit '/'
      click_on 'ポジティブワードを共有する'    
      visit '/posts'
      first(:css, "#post-id-#{post.id} a", text: post.post_word).click

      within '#table-comment' do
        expect(page).to have_content(comment_by_me.body), 'コメントの本文が表示されていません'
        expect(page).to have_content(comment_by_me.user.username), 'コメントの投稿者のフルネームが表示されていません'
      end
    end


    describe 'コメントの作成' do
      it 'コメントを作成できること' do
        login_as(user)
        visit '/posts'
        first(:css, "#post-id-#{post.id} a", text: post.post_word).click
        
        # コメントフォームが存在することを確認
        expect(page).to have_selector('#comment-form')

        fill_in 'comment_body', with: '新規コメント'
        click_on '投稿'

        # コメント投稿後にフラッシュメッセージが表示されることを確認
        expect(page).to have_content('コメントを投稿しました'), 'フラッシュメッセージ「コメントを投稿しました」が表示されていません'
        
        # コメントがデータベースに保存されたことを確認
        comment = Comment.last
        expect(comment.body).to eq('新規コメント')
        expect(comment.user).to eq(user)
        expect(comment.post).to eq(post)

        # 新規作成したコメントの要素がDOMに表示されるまで待機
        expect(page).to have_selector("#comment-#{comment.id}", wait: 5) # wait時間も考慮

        within "#comment-#{comment.id}" do
          expect(page).to have_content('新規コメント'), '新規作成したコメントの本文が表示されていません'
          expect(page).to have_content(user.username), '新規作成したコメントの投稿者のユーザー名が表示されていません'
        end
      end

      it 'コメントの作成に失敗すること' do
        login_as(user)
        visit '/posts'
        first(:css, "#post-id-#{post.id} a", text: post.post_word).click
        expect {
        fill_in 'comment_body', with: ''
        click_on '投稿'
        sleep(0.5)
        }.to change { Comment.count }.by(0), 'コメントが作成されています'
      end
    end

    describe 'コメントの削除' do
      # 削除対象のコメントを各テストケースで明確に作成する
      let!(:comment_to_delete) { create(:comment, user: user, post: post) }

      it 'コメントを削除できること' do
        login_as(user)
        visit '/posts'
        first(:css, "#post-id-#{post.id} a", text: post.post_word).click   
        within("#comment-#{comment_to_delete.id}") do
          expect(page).to have_selector('.delete-comment-button', wait: 5)
          page.accept_confirm do
           find('.delete-comment-button').click
          end
        end

        # フラッシュメッセージが表示されるまで待機
        expect(page).to have_content('コメントを削除しました'), 'コメントの削除が正しく機能していません'   
        
        # 削除したコメントがDOMから消えたことを確認
        expect(page).not_to have_selector("#comment-#{comment_to_delete.id}"), '削除したコメントがページに残っています'
        
        # データベースからも削除されたことを確認
        expect(Comment.find_by(id: comment_to_delete.id)).to be_nil
      end
    end

    describe 'コメントの編集' do
      let!(:comment_to_edit) { create(:comment, user: user, post: post) }

      context '自分のコメントの場合' do
        it 'コメントを編集できること' do
          login_as(user)
          visit '/posts'
          first(:css, "#post-id-#{post.id} a", text: post.post_word).click

          within("#comment-#{comment_to_edit.id}") do
            expect(page).to have_selector('.edit-comment-button') 
            find('.edit-comment-button').click
          end


          expect(page).to have_current_path(edit_comment_path(comment_to_edit))

          fill_in 'comment_body', with: '更新されたコメント'
          click_on '更新'
          expect(page).to have_current_path(post_path(post)) # 更新後に投稿詳細ページに戻ることを想定

          within("#comment-#{comment_to_edit.id}") do
            expect(page).to have_content('更新されたコメント'), '更新されたコメントの本文が表示されていません'
          end
        end
      end

      context '他人のコメントの場合' do
        it '編集ボタン・削除ボタンが表示されないこと' do
          login_as(user)
          visit '/posts'
          first(:css, "#post-id-#{post.id} a", text: post.post_word).click
          within("#comment-#{comment_by_others.id}") do
            expect(page).not_to have_selector('.edit-comment-button'), '他人のコメントに対して編集ボタンが表示されてしまっています'
            expect(page).not_to have_selector('.delete-comment-button'), '他人のコメントに対して削除ボタンが表示されてしまっています'
          end
        end
      end
    end
  end
end