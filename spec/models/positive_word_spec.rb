require 'rails_helper'

RSpec.describe PositiveWord, type: :model do
  let(:target) { create(:target) }
  let(:situation) { create(:situation, target: target) }

  it '有効な属性がある場合は有効である' do
    positive_word = build(:positive_word, target: target, situation: situation)
    expect(positive_word).to be_valid
  end

  it 'targetがnilの場合は無効である' do
    positive_word = build(:positive_word, target: nil, situation: situation)
    expect(positive_word).to_not be_valid
  end

  it 'situationがnilの場合は無効である' do
    positive_word = build(:positive_word, target: target, situation: nil)
    expect(positive_word).to_not be_valid
  end

  it 'is_custom? が true の場合、target と situation がなくても有効である' do
    positive_word = build(:positive_word, target: nil, situation: nil)
    allow(positive_word).to receive(:is_custom?).and_return(true)
    expect(positive_word).to be_valid
  end
end
