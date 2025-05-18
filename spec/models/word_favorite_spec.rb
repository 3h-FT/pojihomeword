require 'rails_helper'

RSpec.describe WordFavorite, type: :model do
  context "有効な場合" do
    it "お気に入り登録が有効な場合" do
      word_favorite = build(:word_favorite)
      expect(word_favorite).to be_valid
    end
  end

  context 'ユーザーとワードの組み合わせがユニークでない場合' do
    it '無効であること' do
      word_favorite = create(:word_favorite)
      new_word_favorite = build(:word_favorite, user: word_favorite.user, positive_word: word_favorite.positive_word)
      expect(new_word_favorite).to_not be_valid
      expect(new_word_favorite.errors[:user_id]).to be_present
    end
  end
end
