require 'test_helper'

class PlaylistItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should save without playlist_id' do
    playlist_item = playlist_items(:without_playlist_id)
    assert_not playlist_item.save, 'Saved without playlist_id'
  end

  test 'should save without song_id' do
    playlist_item = playlist_items(:without_song_id)
    assert_not playlist_item.save, 'Saved without song_id'
  end

end
