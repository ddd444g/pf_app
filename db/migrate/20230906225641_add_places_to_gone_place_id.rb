class AddPlacesToGonePlaceId < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :gone_place_id, :integer
  end
end
