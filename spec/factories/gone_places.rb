FactoryBot.define do
  factory :gone_place do
    name { "test_name" }
    latitude { 1 }
    longitude { 1 }
    review { "test_review" }
    score { 1 }
    googlemap_name { "test_googlemap_name" }
    address { "test_address" }
    once_again { false }
    recommend { false }
    website { "https.test_website.jp" }
  end
end
