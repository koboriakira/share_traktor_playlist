require 'sucker_punch/async_syntax'
require 'rexml/document'

class AmazonJob < ActiveJob::Base
  queue_as :default

  SLEEP_TIME = 15

  def perform(playlists)
    playlists.each do |playlist|
      sleep(SLEEP_TIME)
      @song = Song.new()
      @song[:playlist_id] = playlist[:PLAYLIST_ID]
      @song[:title] = playlist[:TITLE]
      @song[:artist_id] = playlist[:ARTIST_ID]
      Amazon::Ecs.debug = true
      amz_search_results = Amazon::Ecs.item_search(
        playlist[:TITLE] + playlist[:ARTIST_NAME], # キーワード
        search_index: 'MP3Downloads', # 検索対象の設定
        dataType: 'script',
        responce_group: 'Small',
        country:  'jp'
      )
      unless amz_search_results.items.empty? then
        @song[:amzmp3url] = amz_search_results.items[0].get('DetailPageURL')
      end

      if @song.save then
        puts "save success"
      else
        puts "save failure"
      end
    end
  end
end
