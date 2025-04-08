FactoryBot.define do
  factory :user do
    username { "test_user" }
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
