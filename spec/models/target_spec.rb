require 'rails_helper'

RSpec.describe Target, type: :model do
  it '名前があれば有効であること' do
    target = build(:target)
    expect(target).to be_valid
  end

  it '名前がなければ無効であること' do
    target = build(:target)
    target.name = nil
    expect(target).to_not be_valid
  end
end
