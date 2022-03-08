class ChangeColumnNameUserIdToClientId < ActiveRecord::Migration[6.0]
  def change
    rename_column :addresses, :user_id, :client_id
  end
end
