class CreatePlanPlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_places do |t|
      t.string :plan_place_name
      t.string :memo
      t.float :latitude
      t.float :longitude
      t.integer :user_id
      t.integer :plan_id

      t.timestamps
    end
  end
end
