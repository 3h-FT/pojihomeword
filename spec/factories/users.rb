FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
  end
end
