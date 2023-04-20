class RecommendPlace < ApplicationRecord
  belongs_to :user
  has_one :gone_place

  validates :recommend_place_name, presence: true
  validates :recommend_comment, presence: true
end
