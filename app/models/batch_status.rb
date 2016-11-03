class BatchStatus < ActiveRecord::Base
  WAITING = 0
  PROCESSING = 1
  COMPLETE = 2

  def is_waiting?
    status == BatchStatus::WAITING
  end
end
