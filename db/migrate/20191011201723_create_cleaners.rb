class CreateCleaners < ActiveRecord::Migration[6.0]
  def change
    create_table :cleaners do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :phone
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
