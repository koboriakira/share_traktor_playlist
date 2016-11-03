class CreatePlaylistItems < ActiveRecord::Migration
  def change
    create_table :playlist_items do |t|
      t.integer :playlist_id
      t.integer :song_id
      t.string :comment

      t.timestamps null: false
    end
  end
end
