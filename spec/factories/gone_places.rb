FactoryBot.define do
  factory :gone_place do
    name { "TestName" }
    latitude { 1 }
    longitude { 1 }
    review { "TestReview" }
    score { 1 }
    googlemap_name { "TestGooglemapName" }
    address { "Testaddress" }
    once_again { false }
    recommend { false }
    website { "HttpTsestWebsiteJp" }
  end
end
