require 'test_helper'

class BatchStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'Return true when status is STOP' do
    batch_status = batch_statuses(:waiting)
    assert batch_status.is_waiting?
  end
end
