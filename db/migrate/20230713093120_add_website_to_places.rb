class AddWebsiteToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :website, :string
  end
end
