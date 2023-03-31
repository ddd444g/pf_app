class AddPlaceIdToGonePlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :gone_places, :place_id, :integer
  end
end
