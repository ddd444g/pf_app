class Category < ApplicationRecord
  has_many :places
  has_many :gone_places
  has_many :plan_places
end
