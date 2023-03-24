class User < ApplicationRecord
  has_secure_password

  has_many :places
  has_many :gone_places

  validates :name, presence: true
  validates :email, presence: true
end
