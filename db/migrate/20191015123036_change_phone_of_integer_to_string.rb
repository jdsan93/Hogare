class ChangePhoneOfIntegerToString < ActiveRecord::Migration[6.0]
  def change
    change_column :admins, :phone, :string
    change_column :clients, :phone, :string
    change_column :cleaners, :phone, :string
  end
end
