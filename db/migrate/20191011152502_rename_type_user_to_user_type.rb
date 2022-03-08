class RenameTypeUserToUserType < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :type_user, :user_type
  end
end
