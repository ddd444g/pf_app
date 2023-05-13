class AddStartTimeToPlanPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_places, :start_time, :datetime
  end
end
