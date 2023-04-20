FactoryBot.define do
  factory :recommend_place do
    recommend_place_name { "MyString" }
    recommend_comment { "MyString" }
    user_id { 1 }
    gone_place_id { 1 }
  end
end
