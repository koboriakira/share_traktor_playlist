class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :user_id
      t.string :file_name
      t.integer :file_type
      t.string :title
      t.string :remarks
      t.timestamps :played_date

      t.timestamps null: false
    end
  end
end
