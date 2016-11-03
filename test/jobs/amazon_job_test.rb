require 'test_helper'

class AmazonJobTest < ActiveJob::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'perform_later' do
    BatchStatus.create(song_id: 1, keyword: 'ride on time', status: 0)
    AmazonJob.perform_later
  end
end
