class AddRecommendIdToGonePlaces < ActiveRecord::Migration[6.1]
  def change
    add_reference :gone_places, :recommend_place, foreign_key: true, null: true
  end
end
