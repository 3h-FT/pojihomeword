FactoryBot.define do
  factory :positive_word do
    word { "よく頑張ったね、これからが楽しみだ！" }
    is_custom { false }
    association :target
    association :situation
    association :user
  end
end
