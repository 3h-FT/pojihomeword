# spec/system/comments_spec.rb
require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let(:user)  { create(:user) }
  let(:post)  { create(:post) }
  let!(:own_comment)     { create(:comment, user: user,  post: post) }
  let!(:others_comment)  { create(:comment, post: post) }

  before do
    login_as(user)
    visit posts_path
    first(:css, "#post-id-#{post.id} a", text: post.post_word).click
  end

  describe '一覧表示' do
    it '自分のコメントとユーザー名が表示される' do
      within '#table-comment' do
        expect(page).to have_text(own_comment.body), '「(own_comment.body」が表示されていません'
        expect(page).to have_text(user.username), '「user.username」が表示されていません'
      end
    end
  end

  describe 'コメント作成 (Turbo Stream)' do
    context '成功' do
      it 'フォーム送信後に一覧へ即時反映される', js: true do
        fill_in 'コメント', with: '新規コメント'
        click_on '投稿'

        # Turbo Stream でフォームがリセットされる
        within '#comment-form' do
          expect(find('textarea').value).to eq ''
        end

        within '#table-comment' do
          expect(page).to have_text('新規コメント'), '「新規コメント」が表示されていません'
          expect(first('h3').text).to eq(user.username), '「user.username」が表示されていません'
        end
      end

      it '自分のコメントをインラインで更新できる', js: true do
        within "#comment-#{own_comment.id}" do
          find('.edit-comment-button').click
        end

        expect(page).to have_selector("turbo-frame#comment-form-#{own_comment.id}", wait: 5)

        within "turbo-frame#comment-form-#{own_comment.id}" do
          expect(page).to have_field('コメントの編集', wait: 10)
          fill_in 'コメントの編集', with: '更新されたコメント'
          click_on '更新'
        end
  
        within("#comment-#{own_comment.id}", visible: true, wait: 5) do
          expect(page).to have_text('更新されたコメント', wait: 5), '編集内容が反映されていません'
        end
      end
    end
  end

  describe 'コメント削除 (Turbo Stream)' do
    it '自分のコメントを削除できる', js: true do
      within "#comment-#{own_comment.id}" do
        accept_confirm { find('.delete-comment-button').click }
      end

      # Turbo Stream remove 後に DOM から要素が消えているか
      expect(page).not_to have_selector("#comment-#{own_comment.id}"), 'コメントが削除されていません'
    end
  end

  describe '他ユーザーのコメント' do
    it '編集・削除ボタンが表示されない' do
      within "#comment-#{others_comment.id}" do
        expect(page).not_to have_selector('.edit-comment-button'), '編集ボタンが表示されています'
        expect(page).not_to have_selector('.delete-comment-button'), '削除ボタンが表示されています'
      end
    end
  end
end
