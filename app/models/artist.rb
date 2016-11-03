class Artist < ActiveRecord::Base
  validates :artist_name, presence: true
  has_many :songs, foreign_key: "artist_id"
end
