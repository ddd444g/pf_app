class User < ApplicationRecord
  has_secure_password

  has_many :places, dependent: :delete_all
  has_many :gone_places, dependent: :destroy
  has_many :recommend_places, dependent: :delete_all
  has_many :plans, dependent: :delete_all
  has_many :plan_places, dependent: :delete_all

  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, { presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } }
end
