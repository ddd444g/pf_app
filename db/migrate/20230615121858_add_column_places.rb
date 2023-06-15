class AddColumnPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :visited, :boolean, null: false, default: false
  end
end
