class RemoveNamePhoneAddressFromUsers < ActiveRecord::Migration[6.0]
  def change

    remove_column :users, :name, :string

    remove_column :users, :phone, :string

    remove_column :users, :address, :string
  end
end
