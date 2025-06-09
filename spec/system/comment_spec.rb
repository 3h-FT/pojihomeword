#require 'rails_helper'

#RSpec.describe 'Comments', type: :system do
#  let(:user) { create(:user) }
#  let(:post) { create(:post) }
#  let!(:comment_by_me) { create(:comment, user: user, post: post) }
#  let!(:comment_by_others) { create(:comment, post: post) }

#  before do
#    login_as(user)
#    visit posts_path
#    first(:css, "#post-id-#{post.id} a", text: post.post_word).click
#  end

#  describe 'コメント一覧表示' do
#    it '自分のコメントが表示される' do
#      within '#table-comment' do
#        expect(page).to have_text(comment_by_me.body), 'コメントに「コメント内容」が表示されていません'
#        expect(page).to have_text(comment_by_me.user.username), 'コメントに「投稿者」が表示されていません'
#      end
#    end
#  end

#  describe 'コメント作成' do
#    context 'コメント作成が成功した場合' do
#      it '新しいコメントを投稿できる' do
#        fill_in 'comment_body', with: '新規コメント'
#        click_on '投稿'

#        expect(page).to have_text('コメントを投稿しました'), 'フラッシュメッセージ「コメントを投稿しました」が表示されていません'

#        comment = Comment.last
#        expect(comment.body).to eq('新規コメント'), 'ページ内に「編集ワード」が表示されていません'
#        expect(comment.user).to eq(user), 'ページ内に「編集ワード」が表示されていません'
#        expect(comment.post).to eq(post), 'ページ内に「編集ワード」が表示されていません'

#        within "#comment-#{comment.id}" do
#          expect(page).to have_text('新規コメント'), 'ページ内に「編集ワード」が表示されていません'
#          expect(page).to have_text(user.username), 'ページ内に「編集ワード」が表示されていません'
#        end
#      end
#    end

#    context 'コメント作成の失敗' do
#      it 'コメント本文が空では投稿できない' do
#        expect {
#          fill_in 'comment_body', with: ''
#          click_on '投稿'
#        }.not_to change { Comment.count }
#        expect(page).to have_text('コメントを投稿できません'), 'フラッシュメッセージ「コメントを投稿できません」が表示されていません'
#      end
#    end
#  end

#  describe 'コメントの編集・削除' do
#    let!(:editable_comment) { create(:comment, user: user, post: post) }

#    context '自分のコメントの場合' do
#      it '編集できる' do
#        within "#comment-#{editable_comment.id}" do
#          find('.edit-comment-button').click
#        end

#        expect(page).to have_current_path(edit_comment_path(editable_comment))

#        fill_in 'comment_body', with: '更新されたコメント'
#        click_on '更新'

#        expect(page).to have_current_path(post_path(post))
#        within "#comment-#{editable_comment.id}" do
#          expect(page).to have_text('更新されたコメント'), 'ページ内に「編集ワード」が表示されていません'
#        end
#      end

#      it '削除できる' do
#        within "#comment-#{editable_comment.id}" do
#          expect(page).to have_selector('.delete-comment-button')
#          click_button class: 'delete-comment-button'
#        end

#        expect(page).to have_text('コメントを削除しました'), 'フラッシュメッセージ「コメントを削除しました」が表示されていません'
#        expect(page).not_to have_selector("#comment-#{editable_comment.id}")
#      end
#    end

#    context '他人のコメントの場合' do
#      it '編集・削除ボタンが表示されない' do
#        within "#comment-#{comment_by_others.id}" do
#          expect(page).not_to have_selector('.edit-comment-button')
#          expect(page).not_to have_selector('.delete-comment-button')
#        end
#      end
#    end
#  end
#end
