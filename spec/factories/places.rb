FactoryBot.define do
  factory :place do
    name { "test_place" }
    latitude { 1 }
    longitude { 1 }
    memo { "test_memo" }
    googlemap_name { "test_googlemap_name" }
    address { "test_address" }
    rating { 5 }
    visited { false }
    website { "https.test_website.jp" }
  end
end
