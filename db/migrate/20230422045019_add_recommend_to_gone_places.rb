class AddRecommendToGonePlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :gone_places, :recommend, :boolean, null: false, default: false
  end
end
