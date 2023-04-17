class CreateRecommendPlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :recommend_places do |t|
      t.string :recommend_place_name
      t.string :recommend_comment
      t.integer :user_id
      t.integer :gone_place_id

      t.timestamps
    end
  end
end
