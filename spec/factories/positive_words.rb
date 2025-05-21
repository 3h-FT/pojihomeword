FactoryBot.define do
  factory :positive_word do
    sequence(:word) { |n| "ポジティブワード#{n}" }
    is_custom { false }
    association :target
    association :situation
    association :user
  end
end
