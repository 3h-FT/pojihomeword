require 'rails_helper'

RSpec.describe Comment, type: :model do
    context "有効な場合" do
    it "全てのフィールドが有効な場合" do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    it 'コメントが65535文字以内の場合' do
      comment = build(:comment)
      comment.body = 'a' * 65535
      expect(comment).to be_valid
    end
  end

  context '無効な場合' do
    it '投稿ワードがない場合' do
      comment = build(:comment)
      comment.body = nil
      expect(comment).to be_invalid
    end

    it '投稿ワードが65536文字以上の場合' do
      comment = build(:comment)
      comment.body = 'a' * 65536
      expect(comment).to be_invalid
    end
  end
end
