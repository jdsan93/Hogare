class AddAttributesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :type_user, :integer
  end
end
