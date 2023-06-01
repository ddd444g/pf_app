class AddaddressToPlanPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_places, :googlemap_name, :string
    add_column :plan_places, :address, :string
    add_column :plan_places, :rating, :float
  end
end
