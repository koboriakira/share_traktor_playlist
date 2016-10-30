require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should not save without file_name' do
    playlist = playlists(:without_file_name)
    assert_not playlist.save, 'Saved without file_name'
  end

  test 'should not save without title' do
    playlist = playlists(:without_title)
    assert_not playlist.save, 'Saved without title'
  end
end
