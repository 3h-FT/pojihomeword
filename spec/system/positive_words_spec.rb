require 'rails_helper'

RSpec.describe "PositiveWords", type: :system do
  let(:user) { create(:user) }
  let!(:target) { Target.find_or_create_by(name: "自分自身") }
  let!(:situation) { Situation.find_or_create_by(name: "自分の成功を祝う", target: target) }
  let!(:positive_word) { PositiveWord.find_or_create_by(word: "よく頑張ったね、これからが楽しみだ！", target: target, situation: situation) }

  it 'シチュエーション選択後、適したポジティブワードが表示されるか' do
    visit positive_words_path

    select '自分自身', from: 'target_id'
    click_button '表示'

    select '自分の成功を祝う', from: 'situation_id'
    click_button '表示'

    expect(page).to have_content('よく頑張ったね、これからが楽しみだ！'), 'ページ内に「よく頑張ったね、これからが楽しみだ！」が表示されていません'
  end
end
