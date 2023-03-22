class GonePlace < ApplicationRecord
  belongs_to :user
  has_one :place
  validates :name, presence: true
  validates :review, presence: true
  validates :score, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  geocoded_by :name
  after_validation :geocode, if: :name_changed?
end
