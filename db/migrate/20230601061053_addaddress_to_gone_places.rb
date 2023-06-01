class AddaddressToGonePlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :gone_places, :googlemap_name, :string
    add_column :gone_places, :address, :string
    add_column :gone_places, :rating, :float
  end
end
