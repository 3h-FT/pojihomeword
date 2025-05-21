FactoryBot.define do
  factory :comment do
    association :user
    association :post
    sequence(:body) { |n| "本文#{n}" }
  end
end
