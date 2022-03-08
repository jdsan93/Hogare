class RemoveColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :services, :address
    add_column :services, :location_id, :integer
    remove_column :services, :user_id
    add_column :services, :order_id, :integer
  end
end
