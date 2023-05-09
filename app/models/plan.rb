class Plan < ApplicationRecord
  belongs_to :user

  validates :plan_name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :plan_color, presence: true
  validate :date_before_start
  validate :date_before_end
  validate :start_same_end

  def date_before_start
    return if start_time.blank?
    errors.add(:start_time, "は過去の日付は選択できません") if start_time < Date.today
  end

  def date_before_end
    if end_time.blank? || start_time.blank?
      return
    end
    errors.add(:end_time, "は開始日時より後にして下さい") if end_time < start_time
  end

  def start_same_end
    if end_time == start_time
      errors.add(:end_time, "は開始日時より、1分以上後にして下さい")
    end
  end
end
