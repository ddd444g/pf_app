class AddPlaceIdToPlanPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_places, :place_id, :integer
  end
end
