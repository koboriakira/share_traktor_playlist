class Song < ActiveRecord::Base
  validates :title, presence: true
  has_one :playlist_item
  belongs_to :artist
end
