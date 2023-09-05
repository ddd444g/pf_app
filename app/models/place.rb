class Place < ApplicationRecord
  belongs_to :user
  belongs_to :gone_place, optional: true
  belongs_to :recommend_place, optional: true
  belongs_to :category

  has_many :plan_places

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :name, presence: true
  validates :latitude, presence: { message: "で検索し位置を指定してください" }
  validates :longitude, presence: { message: "したい位置にピンを刺してください" }

  # 絞り込み検索機能
  scope :search, -> (keyword) {
    if keyword.present?
      keywords = keyword.split(/[[:blank:]]+/) # 空白でキーワードを分割
      search_conditions = keywords.map do |kw|
        "(name LIKE :kw OR memo LIKE :kw OR googlemap_name LIKE :kw OR address LIKE :kw)"
      end .join(" OR ")
      where(search_conditions, keywords.map { |kw| { kw: "%#{kw}%" } }.reduce({}, :merge))
    else
      all
    end
  }

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
