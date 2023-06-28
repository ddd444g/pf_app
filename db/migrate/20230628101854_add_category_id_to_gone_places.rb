class AddCategoryIdToGonePlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :gone_places, :category_id, :integer
  end
end
