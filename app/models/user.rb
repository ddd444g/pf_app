class User < ApplicationRecord
  has_many :places
  has_many :gone_places
  validates :name, presence: true
end
