class RemovePaidFromOrders < ActiveRecord::Migration[6.0]
  def change
      remove_column :orders, :paid
  end
end
