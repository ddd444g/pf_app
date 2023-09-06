FactoryBot.define do
  factory :recommend_place do
    recommend_place_name { "MyString" }
    recommend_comment { "test_comment" }
    googlemap_name { "test_googlemap_name" }
    address { "test_address" }
    website { "https.test_website.jp" }
  end
end
