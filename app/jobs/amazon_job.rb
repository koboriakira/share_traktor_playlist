require 'sucker_punch/async_syntax'
require 'rexml/document'

class AmazonJob < ActiveJob::Base
  queue_as :default

  def perform()
    sleep(5)
    puts "AmazonJob.test"
  end
end
