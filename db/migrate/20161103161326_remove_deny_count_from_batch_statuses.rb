class RemoveDenyCountFromBatchStatuses < ActiveRecord::Migration
  def change
    remove_column :batch_statuses, :deny_count, :integer
  end
end
