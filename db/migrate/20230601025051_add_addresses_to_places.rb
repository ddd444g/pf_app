class AddAddressesToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :address, :string
  end
end
