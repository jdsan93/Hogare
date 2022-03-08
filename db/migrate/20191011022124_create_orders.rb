class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :total_price, default: 0
      t.integer :user_id
      t.integer :admin_id
      t.boolean :paid, default: false

      t.timestamps
    end
  end
end
