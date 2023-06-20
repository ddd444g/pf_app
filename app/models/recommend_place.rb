class RecommendPlace < ApplicationRecord
  belongs_to :user
  has_one :gone_place
  has_many :places

  validates :recommend_place_name, presence: true
  validates :recommend_comment, presence: true

  # 絞り込み検索機能
  scope :search, -> (keyword) {
    if keyword.present?
      keywords = keyword.split(/[[:blank:]]+/) # 空白でキーワードを分割
      search_conditions = keywords.map do |kw|
        "(recommend_place_name LIKE :kw OR recommend_comment LIKE :kw OR googlemap_name LIKE :kw OR address LIKE :kw)"
      end.join(" OR ")
      where(search_conditions, keywords.map { |kw| { kw: "%#{kw}%" } }.reduce({}, :merge))
    else
      all
    end
  }

  # 並び替え機能
  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :rating, -> { order(rating: :desc) }

  def self.sort_recommend_places(sort_param)
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
