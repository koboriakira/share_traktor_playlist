class BatchStatus < ActiveRecord::Base
  WAITING = 0
  PROCESSING = 1
  COMPLETE = 2

  def is_waiting?
    status == BatchStatus::WAITING
  end

  def update_status(arg_val)
    self.status = arg_val
    if self.save then
      logger.debug('BatchStatus更新: status = ' + arg_val.to_s)
    end
  end
end
