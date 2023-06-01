class ChangeDataRatingToPlace < ActiveRecord::Migration[6.1]
  def change
    change_column :places, :rating, :float
  end
end
