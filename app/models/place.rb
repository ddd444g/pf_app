class Place < ApplicationRecord
  belongs_to :user
  geocoded_by :name
  after_validation :geocode, if: :name_changed?
end
