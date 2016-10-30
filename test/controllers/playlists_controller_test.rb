require 'test_helper'

class PlaylistsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should post confirm' do
    post(:confirm, {'content' => {
      'upload_file' => '/Users/koboriakira/workspace/share_traktor_playlist/test/test.nml',
      'file_name' => 'test.nml'}
    })
    assert_template :confirm
    assert_response :success
  end

  
end
