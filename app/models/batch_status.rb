class BatchStatus < ActiveRecord::Base
  STOP = 0
  PROCESSING = 1

  def isStop?
    status == BatchStatus::STOP
  end
end
