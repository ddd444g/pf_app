FactoryBot.define do
  factory :gone_place do
    name { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
    review { "MyString" }
    score { 1 }
    user_id { 1 }
  end
end
