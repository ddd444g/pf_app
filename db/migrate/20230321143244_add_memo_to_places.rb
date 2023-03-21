class AddMemoToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :memo, :string
  end
end
