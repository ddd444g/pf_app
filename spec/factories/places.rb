FactoryBot.define do
  factory :place do
    name { "TestPlace" }
    latitude { 1 }
    longitude { 1 }
    memo { "TestMemo" }
    googlemap_name { "TestGooglemapName" }
    address { "t
      TestAddress" }
    rating { 5 }
    visited { false }
    website { "HttpsTestWebsiteJp" }
  end
end
