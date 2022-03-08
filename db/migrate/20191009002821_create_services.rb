class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.datetime :date
      t.integer :sate
      t.string :address
      t.integer :user_id
      t.integer :worker_id
      t.integer :price

      t.timestamps
    end
  end
end
