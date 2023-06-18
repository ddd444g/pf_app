class RecommendPlace < ApplicationRecord
  belongs_to :user
  has_one :gone_place
  has_many :places

  validates :recommend_place_name, presence: true
  validates :recommend_comment, presence: true

    # 並び替え機能
    scope :latest, -> { order(created_at: :desc) }
    scope :old, -> { order(created_at: :asc) }
    scope :rating, -> { joins(:gone_place).order('gone_places.rating DESC') }

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
