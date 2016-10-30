class Artist < ActiveRecord::Base
  validates :artist_name, presence: true
  belongs_to :song
end
