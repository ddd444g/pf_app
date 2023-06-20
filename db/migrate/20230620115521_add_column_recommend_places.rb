class AddColumnRecommendPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :recommend_places, :googlemap_name, :string
    add_column :recommend_places, :address, :string
  end
end
