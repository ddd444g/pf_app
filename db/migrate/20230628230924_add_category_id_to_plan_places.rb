class AddCategoryIdToPlanPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_places, :category_id, :integer
  end
end
