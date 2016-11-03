class Playlist < ActiveRecord::Base
  validates :file_name, presence: true
  validates :title, presence: true
  has_many :playlist_items, dependent: :destroy
end
