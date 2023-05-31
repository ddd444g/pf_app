class AddGooglemapNameToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :googlemap_name, :string
  end
end
