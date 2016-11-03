require 'test_helper'

class PlaylistsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should post create' do
    post(:create, {'content' => {
      'upload_file' => fixture_file_upload('../test.nml', 'text/xml'),
      'title'       => 'test-title'}
    })
    assert Playlist.find_by(id: 940567029)
    assert_equal PlaylistItem.where(playlist_id: 940567029).length, 2
    assert_equal Song.find_by(title: 'リライト').artist.artist_name, 'ASIAN KUNG-FU GENERATION'
    assert_equal redirect_to_url, 'http://test.host/playlists/940567029'
  end
end
