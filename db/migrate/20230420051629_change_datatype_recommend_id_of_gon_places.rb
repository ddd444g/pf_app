class ChangeDatatypeRecommendIdOfGonPlaces < ActiveRecord::Migration[6.1]
  def change
    change_column :gone_places, :recommend_place_id, :integer
  end
end
