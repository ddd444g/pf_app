class RemoveForeignKeyConstraint < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :gone_places, :recommend_places
  end
end
