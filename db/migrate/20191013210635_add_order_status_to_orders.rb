class AddOrderStatusToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :order_status, :integer
    change_column_default :orders, :order_status, 1
  end
end
