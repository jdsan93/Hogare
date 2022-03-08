class SetDefaultValues < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :type_user, 1
    change_column_default :services, :status, 1
  end
end
