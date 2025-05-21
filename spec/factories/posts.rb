FactoryBot.define do
  factory :post do
    association :user
    association :positive_word
    sequence(:post_word) { |n| "投稿ワード#{n}" }
    sequence(:caption) { |n| "キャプション#{n}" }
  end
end
