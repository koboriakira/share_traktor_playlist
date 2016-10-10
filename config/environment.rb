# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Amazon Advertising API
Amazon::Ecs.options = {
      associate_tag:     'privatebeats-22',
      AWS_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      AWS_secret_key:    ENV["AWS_SECRET_ACCESS_KEY"]
}
