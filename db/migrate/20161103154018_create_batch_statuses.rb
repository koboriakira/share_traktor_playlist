class CreateBatchStatuses < ActiveRecord::Migration
  def change
    create_table :batch_statuses do |t|
      t.integer :status
      t.integer :deny_count

      t.timestamps null: false
    end
  end
end
