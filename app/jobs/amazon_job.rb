require 'sucker_punch/async_syntax'

class AmazonJob < ActiveJob::Base
  queue_as :default

  SLEEP_TIME = 1

  def perform()
    unless processing_batch_statused.empty? then
      return
    end

    Amazon::Ecs.debug = true
    while(batch = waiting_batch_status)
      batch.update_status(BatchStatus::PROCESSING)
      sleep(SLEEP_TIME)
      song = Song.find_by(id: batch.song_id)
      sleep(SLEEP_TIME)
      amz_search_results = amz_item_search(batch.keyword)
      unless amz_search_results.items.empty? then
        puts '検索ヒット'
        song.amzmp3url = amz_search_results.items[0].get('DetailPageURL');
      else
        puts '検索ヒットせず'
        song.amzmp3url = 'none'
      end
      if song.save then
        puts 'amzmp3urlの更新成功'
      end
      batch.update_status(BatchStatus::COMPLETE)
      sleep(SLEEP_TIME)
    end
  end

  private
    def processing_batch_statused
      BatchStatus.where(status: BatchStatus::PROCESSING)
    end

  private
    def waiting_batch_status
      BatchStatus.find_by(status: BatchStatus::WAITING)
    end

  private
    def amz_item_search(keyword)
      Amazon::Ecs.item_search(
        keyword, # キーワード
        search_index: 'MP3Downloads', # 検索対象の設定
        dataType: 'script',
        responce_group: 'Small',
        country:  'jp'
      )
    end
end
