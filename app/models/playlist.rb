class Playlist < ActiveRecord::Base
  has_many :songs, dependent: :destroy
end
