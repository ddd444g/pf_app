class AddWebsiteToPlanPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_places, :website, :string
  end
end
