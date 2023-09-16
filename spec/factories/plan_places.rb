FactoryBot.define do
  factory :plan_place do
    plan_place_name { "TestPlace" }
    latitude { 1 }
    longitude { 1 }
    memo { "TestMemo" }
    googlemap_name { "TestGooglemapName" }
    address { "TestAddress" }
    website { "HttpsTestWebsiteJp" }
  end
end
