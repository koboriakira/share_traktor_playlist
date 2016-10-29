class Song < ActiveRecord::Base
  belongs_to :playlist
  has_one :artist, foreign_key: "id"
end
