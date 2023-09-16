class PlanPlace < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  belongs_to :place, optional: true
  belongs_to :gone_place, optional: true
  belongs_to :category

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :plan_place_name, presence: true
  validates :latitude, presence: { message: "で検索し位置を指定してください" }
  validates :longitude, presence: { message: "したい位置にピンを刺してください" }

  validate :plan_place_start_time_within_plan

  # 予定の期間内でしか訪問予定時刻を登録出来ないようにする処理
  def plan_place_start_time_within_plan
    if start_time.present? && (start_time < plan.start_time || start_time > plan.end_time)
      errors.add(:start_time, "はプランの期間内で設定してください")
    end
  end
end
