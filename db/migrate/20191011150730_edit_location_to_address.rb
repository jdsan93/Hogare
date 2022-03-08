class EditLocationToAddress < ActiveRecord::Migration[6.0]
  def change
    rename_column :services, :location_id, :address_id
  end
end
