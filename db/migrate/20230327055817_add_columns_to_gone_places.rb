class AddColumnsToGonePlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :gone_places, :once_again, :boolean, default: false, null: false
  end
end
