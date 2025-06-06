require 'rails_helper'

RSpec.describe "PositiveWords", type: :system do
  let(:user) { create(:user) }

  # is_seeded: true を明示的に設定してデータを作成
  let!(:target_seeded) { Target.find_or_create_by!(name: "自分自身", is_seeded: true) }
  let!(:situation_seeded) { Situation.find_or_create_by!(name: "自分の成功を祝う", target: target_seeded, is_seeded: true) }
  let!(:positive_word_seeded) { PositiveWord.find_or_create_by!(word: "よく頑張ったね、これからが楽しみだ！", target: target_seeded, situation: situation_seeded, is_custom: false, user: nil) }

  it 'シチュエーション選択後、適したポジティブワードが表示されるか' do
    visit positive_words_path

    # is_seeded: true のデータが選択肢に表示されることを確認
    select '自分自身', from: 'target_id'
    click_button '表示'

    # is_seeded: true のデータが選択肢に表示されることを確認
    select '自分の成功を祝う', from: 'situation_id'
    click_button '表示'

    expect(page).to have_content('よく頑張ったね、これからが楽しみだ！'), 'ページ内に「よく頑張ったね、これからが楽しみだ！」が表示されていません'
  end
end