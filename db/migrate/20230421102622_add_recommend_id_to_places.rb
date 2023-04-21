class AddRecommendIdToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :recommend_place_id, :integer
  end
end
