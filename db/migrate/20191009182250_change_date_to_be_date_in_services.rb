class ChangeDateToBeDateInServices < ActiveRecord::Migration[6.0]
  def change
    change_column :services, :date, :date
  end
end
