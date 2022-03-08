class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :services, :sate, :status
  end
end
