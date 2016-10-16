require 'rexml/document'

class StaticPagesController < ApplicationController
  def home
  end

  def testupload
    content = params[:content][:upload_file]

    @playlist = Playlist.new
    @playlist[:user_id] = 1
    @playlist[:file_name] = content.original_filename
    @playlist[:file_type] = 1
    playlist_id = -1
    if @playlist.save then
      playlist_id = @playlist[:id]
    else
      return
    end

    @content = {}
    @content[:filename] = content.original_filename
    playlist_xml = REXML::Document.new(open(content))
    primary_keys = []
    playlist_xml.elements.each('NML/PLAYLISTS/NODE/SUBNODES/NODE/PLAYLIST/ENTRY') do |e|
      primary_keys.push(e.elements["PRIMARYKEY"].attributes["KEY"])
    end

    playlists = []
    playlist_xml.elements.each('NML/COLLECTION/ENTRY') do |e|
      playlist = {}
      playlist[:PLAYLIST_ID] = playlist_id
      playlist[:TITLE] = e.attributes["TITLE"]
      playlist[:ARTIST_NAME] = e.attributes["ARTIST"]
      artist = Artist.find_by(artist_name: playlist[:ARTIST_NAME])
      if artist then
        playlist[:ARTIST_ID] = artist.id
      else
        artist = Artist.new(artist_name: playlist[:ARTIST_NAME])
        if artist.save then
          playlist[:ARTIST_ID] = artist.id
        end
      end
      playlist[:ALBUM_TITLE] = e.elements["ALBUM"].attributes["TITLE"]
      playlist[:TEMPO] = e.elements["TEMPO"].attributes["BPM"]
      playlist[:KEY] = e.elements["MUSICAL_KEY"].attributes["VALUE"]
      playlist[:PATH] = e.elements["LOCATION"].attributes["VOLUME"] +
                        e.elements["LOCATION"].attributes["DIR"] +
                        e.elements["LOCATION"].attributes["FILE"]
    #   Amazon::Ecs.debug = true
    #   sleep(10)
    #   amz_search_results = Amazon::Ecs.item_search(
    #     playlist[:TITLE] + playlist[:ARTIST], # キーワード
    #     search_index: 'MP3Downloads', # 検索対象の設定
    #     dataType: 'script',
    #     responce_group: 'Small',
    #     country:  'jp'
    #   )
    #   unless amz_search_results.items.empty? then
    #     playlist[:AMZ_URL] = amz_search_results.items[0].get('DetailPageURL')
    #   end
      playlists.push(playlist)
    end

    AmazonJob.perform_later(playlists);
    #
    # @content[:playlist] = []
    # primary_keys.each do |key|
    #   playlists.each do |playlist|
    #     if playlist[:PATH] == key then
    #       @content[:playlist].push(playlist)
    #       break;
    #     end
    #   end
    # end
  end

end
