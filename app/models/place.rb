class Place < ApplicationRecord
  belongs_to :user
  belongs_to :gone_place
  geocoded_by :name
  after_validation :geocode, if: :name_changed?
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
