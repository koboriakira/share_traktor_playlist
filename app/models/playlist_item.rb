class PlaylistItem < ActiveRecord::Base
  validates :playlist_id, presence: true
  validates :song_id, presence: true
  belongs_to :playlist
  belongs_to :song
end
