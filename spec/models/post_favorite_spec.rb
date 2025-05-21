require 'rails_helper'

RSpec.describe PostFavorite, type: :model do
  context "有効な場合" do
    it "お気に入り登録が有効な場合" do
      post_favorite = build(:post_favorite)
      expect(post_favorite).to be_valid
    end
  end

  context 'ユーザーとワードの組み合わせがユニークでない場合' do
    it '無効であること' do
      post_favorite = create(:post_favorite)
      new_post_favorite = build(:post_favorite, user: post_favorite.user, post: post_favorite.post)
      expect(new_post_favorite).to_not be_valid
      expect(new_post_favorite.errors[:user_id]).to be_present
    end
  end
end
