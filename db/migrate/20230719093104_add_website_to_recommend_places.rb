class AddWebsiteToRecommendPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :recommend_places, :website, :string
  end
end
