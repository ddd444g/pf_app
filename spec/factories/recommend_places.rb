FactoryBot.define do
  factory :recommend_place do
    recommend_place_name { "MyString" }
    recommend_comment { "Test" }
    googlemap_name { "TestName" }
    address { "TestAddress" }
    website { "TestJp" }
    rating { 5 }
  end
end
