FactoryBot.define do
  factory :post do
    user { nil }
    positive_word { nil }
    caption { "MyText" }
    word { "MyText" }
  end
end
