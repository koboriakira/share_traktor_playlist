require 'test_helper'

class SongTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should not save without title' do
    song = songs(:without_title)
    assert_not song.save
  end

  test 'should save without artist_id' do
    song = songs(:without_artist_id)
    assert song.save, 'Not saved without artist_id'
  end

  test 'should save without amzmp3url' do
    song = songs(:without_amzmp3url)
    assert song.save
  end
end
