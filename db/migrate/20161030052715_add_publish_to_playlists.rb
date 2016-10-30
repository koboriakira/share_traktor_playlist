class AddPublishToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :publish, :boolean
  end
end
