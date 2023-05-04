class Plan < ApplicationRecord
  belongs_to :user

  validates :plan_name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
