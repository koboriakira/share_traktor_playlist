class AddColumnsToBatchStatuses < ActiveRecord::Migration
  def change
    add_column :batch_statuses, :song_id, :integer
    add_column :batch_statuses, :keyword, :string
  end
end
