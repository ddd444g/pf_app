FactoryBot.define do
  factory :plan_place do
    plan_place_name { "test_place" }
    latitude { 1 }
    longitude { 1 }
    memo { "test_memo" }
    googlemap_name { "test_googlemap_name" }
    address { "test_address" }
    website { "https.test_website.jp" }
  end
end
