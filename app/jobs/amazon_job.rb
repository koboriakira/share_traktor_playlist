require 'sucker_punch/async_syntax'

class AmazonJob < ActiveJob::Base
  queue_as :default

  SLEEP_TIME = 15

  def perform(params)
    Amazon::Ecs.debug = true
    params.each do |param|
      song = Song.find_by(id: param[:SONG_ID])
      sleep(SLEEP_TIME)
      amz_search_results = amz_item_search(param[:KEYWORD])
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
