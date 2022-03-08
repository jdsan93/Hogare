class ChangeColumnNameWorkerIdToCleanerIdInServices < ActiveRecord::Migration[6.0]
  def change
    rename_column :services, :worker_id, :cleaner_id
  end
end
