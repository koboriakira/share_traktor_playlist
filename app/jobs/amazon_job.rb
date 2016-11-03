require 'sucker_punch/async_syntax'

class AmazonJob < ActiveJob::Base
  queue_as :default

  SLEEP_TIME = 15

  def perform()
    unless processing_batch_statused.empty? then
      return
    end

    Amazon::Ecs.debug = true
    while(batch = waiting_batch_status)
      debugger
      song = Song.find_by(id: batch.song_id)
      if song.amzmp3url then
        puts '検索済'
        next
      end
      sleep(SLEEP_TIME)
      amz_search_results = amz_item_search(song.artist.artist_name + ' ' + song.title)
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
    end
  end

  # def perform(playlists)
  #   playlists.each do |playlist|
  #     sleep(SLEEP_TIME)
  #     @song = Song.new()
  #     @song[:playlist_id] = playlist[:PLAYLIST_ID]
  #     @song[:title] = playlist[:TITLE]
  #     @song[:artist_id] = playlist[:ARTIST_ID]
  #     Amazon::Ecs.debug = true
  #     amz_search_results = Amazon::Ecs.item_search(
  #       playlist[:TITLE] + playlist[:ARTIST_NAME], # キーワード
  #       search_index: 'MP3Downloads', # 検索対象の設定
  #       dataType: 'script',
  #       responce_group: 'Small',
  #       country:  'jp'
  #     )
  #     unless amz_search_results.items.empty? then
  #       @song[:amzmp3url] = amz_search_results.items[0].get('DetailPageURL')
  #     end
  #
  #     if @song.save then
  #       puts "save success"
  #     else
  #       puts "save failure"
  #     end
  #   end
  # end

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
