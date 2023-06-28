class Category < ApplicationRecord
  has_many :places
  has_many :gone_places
end
