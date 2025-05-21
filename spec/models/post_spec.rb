require 'rails_helper'

RSpec.describe Post, type: :model do
  context "有効な場合" do
    it "全てのフィールドが有効な場合" do
      post = build(:post)
      expect(post).to be_valid
    end

    it '投稿ワードが255文字以内の場合' do
      post = build(:post)
      post.post_word = 'a' * 255
      expect(post).to be_valid
    end
  end

  context '無効な場合' do
    it '投稿ワードがない場合' do
      post = build(:post)
      post.post_word = nil
      expect(post).to be_invalid
    end

    it '投稿ワードが256文字以上の場合' do
      post = build(:post)
      post.post_word = 'a' * 256
      expect(post).to be_invalid
    end
  end
end
