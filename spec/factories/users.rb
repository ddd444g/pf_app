FactoryBot.define do
  factory :user do
    name { 'test' }
    password { "test_password" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password_confirmation { password }
  end
end
