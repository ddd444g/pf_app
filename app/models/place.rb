class Place < ApplicationRecord
  belongs_to :user
  belongs_to :gone_place, optional: true
  belongs_to :recommend_place, optional: true

  has_many :plan_places

  geocoded_by :name
  after_validation :geocode, if: :name_changed?

  validates :name, presence: true
  validates :latitude, presence: { message: "で検索し位置を指定してください" }
  validates :longitude, presence: { message: "したい位置にピンを刺してください" }
end
