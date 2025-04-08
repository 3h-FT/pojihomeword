require 'rails_helper'

RSpec.describe Situation, type: :model do
  context 'バリデーション' do
    it '名前と関連する対象(target)があれば有効であること' do
      situation = build(:situation)
      expect(situation).to be_valid
    end

    it '名前がなければ無効であること' do
      situation = build(:situation, name: nil)
      expect(situation).to_not be_valid
    end

    it 'targetがなければ無効であること' do
      situation = build(:situation, target: nil)
      expect(situation).to_not be_valid
    end
  end
end
