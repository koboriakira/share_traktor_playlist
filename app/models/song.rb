class Song < ActiveRecord::Base
  validates :playlist_id, presence: true
  validates :title, presence: true
  belongs_to :playlist
  has_one :artist, foreign_key: "id"
end
