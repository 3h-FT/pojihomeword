FactoryBot.define do
  factory :post do
    association :user
    association :positive_word
    caption { "MyText" }
    post_word { "MyText" }
  end
end
