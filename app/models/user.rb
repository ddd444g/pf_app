class User < ApplicationRecord
  has_many :places
  has_many :gone_places
  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
end
