FactoryBot.define do
  factory :plan_place do
    plan_place_name { "MyString" }
    memo { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
    user_id { 1 }
    plan_id { 1 }
  end
end
