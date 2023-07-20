class AddWebsiteToGonePlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :gone_places, :website, :string
  end
end
