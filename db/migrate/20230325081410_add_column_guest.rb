class AddColumnGuest < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :guest, :boolean, null: false, default: false
  end
end
