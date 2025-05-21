require 'rails_helper'

RSpec.describe 'お気に入り登録', type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post) }
  let!(:post_favorite) { create(:post_favorite, user: user) }

  it 'お気に入り登録ができること' do
    login_as(user)
    visit '/posts'
    find("#post-favorite-button-#{post.id}").click
    expect(current_path).to eq('/posts'), 'お気に入り登録作成後に、投稿一覧画面が表示されていません'
    expect(page).to have_css("#post-favorite-button-#{post.id}"), "idがpost-favorite-button-#{post.id}のリンクが表示されていません"
  end

  it 'お気に入りを解除できること' do
    login_as(user)
    visit '/posts'
    find("#post-favorite-button-#{post.id}").click
    expect(current_path).to eq('/posts'), 'お気に入り解除後に、投稿一覧画面が表示されていません'
    expect(page).to have_css("#post-favorite-button-#{post.id}"), "idがpost-favorite-button-#{post.id}のリンクが表示されていません"
  end
end
