class Place < ApplicationRecord
  belongs_to :user
  belongs_to :gone_place, optional: true
  belongs_to :recommend_place, optional: true

  has_many :plan_places

  geocoded_by :name
  after_validation :geocode, if: :name_changed?

  validates :name, presence: true
  validates :latitude, presence: { message: "で検索し位置を指定してください" }
  validates :longitude, presence: { message: "したい位置にピンを刺してください" }

  # 並び替え機能
  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :rating, -> { order(rating: :desc) }

  def self.sort_places(sort_param)
    case sort_param
    when "latest"
      latest
    when "old"
      old
    when "rating"
      rating
    else
      all
    end
  end
end
