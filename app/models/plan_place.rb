class PlanPlace < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  geocoded_by :plan_place_name
  after_validation :geocode, if: :plan_place_name_changed?

  validates :plan_place_name, presence: true
  validates :latitude, presence: { message: "で検索し位置を指定してください" }
  validates :longitude, presence: { message: "したい位置にピンを刺してください" }
end
