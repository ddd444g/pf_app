class AddCategoryIdToRecommendPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :recommend_places, :category_id, :integer
  end
end
