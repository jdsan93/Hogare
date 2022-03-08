class ChangeColumnNameUserIdToClientIdToOrders < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :user_id, :client_id
  end
end
