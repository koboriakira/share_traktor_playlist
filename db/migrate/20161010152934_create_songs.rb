class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :playlist_id
      t.string  :title
      t.integer  :artist_id
      t.string  :amzmp3url

      t.timestamps null: false
    end
  end
end
