class GonePlace < ApplicationRecord
  belongs_to :user
  belongs_to :recommend_place

  has_one :place

  validates :name, presence: true
  validates :review, presence: true

  validates :score, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  validates :latitude, presence: { message: "で検索し位置を指定してください" }
  validates :longitude, presence: { message: "したい位置にピンを刺してください" }

  geocoded_by :name
  after_validation :geocode, if: :name_changed?
end
