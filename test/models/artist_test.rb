require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should not save without artist_name' do
    artist = Artist.new
    assert_not artist.save
  end
end
