class CreateGonePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :gone_places do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :review
      t.integer :score
      t.integer :user_id

      t.timestamps
    end
  end
end
