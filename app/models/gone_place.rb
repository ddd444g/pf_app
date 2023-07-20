class GonePlace < ApplicationRecord
  belongs_to :user
  belongs_to :recommend_place, optional: true, dependent: :destroy
  belongs_to :category

  has_one :place

  has_many :plan_places

  validates :name, presence: true
  validates :review, presence: true

  validates :score, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  validates :latitude, presence: { message: "で検索し位置を指定してください" }
  validates :longitude, presence: { message: "したい位置にピンを刺してください" }
  validates :website, presence: true

  geocoded_by :name
  after_validation :geocode, if: :name_changed?

  # 絞り込み検索機能
  scope :search, -> (keyword) {
    if keyword.present?
      keywords = keyword.split(/[[:blank:]]+/) # 空白でキーワードを分割
      search_conditions = keywords.map do |kw|
        "(name LIKE :kw OR review LIKE :kw OR googlemap_name LIKE :kw OR address LIKE :kw)"
      end .join(" OR ")
      where(search_conditions, keywords.map { |kw| { kw: "%#{kw}%" } }.reduce({}, :merge))
    else
      all
    end
  }

  # 並び替え機能
  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :score, -> { order(score: :desc) }
  scope :rating, -> { order(rating: :desc) }

  def self.sort_gone_places(sort_param)
    case sort_param
    when "latest"
      latest
    when "old"
      old
    when "score"
      score
    when "rating"
      rating
    else
      all
    end
  end
end
