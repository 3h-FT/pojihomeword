FactoryBot.define do
  factory :situation do
    name { "自分の成功を祝う" }
    association :target
  end
end
