require 'rexml/document'

class StaticPagesController < ApplicationController
  def home
  end

  def testupload
    content = params[:content][:upload_file]
    @content = {}
    @content[:filename] = content.original_filename
    # @content[:filecontent] = content.read.force_encoding("UTF-8")
    playlist_xml = REXML::Document.new(open(content))

    primary_keys = []
    playlist_xml.elements.each('NML/PLAYLISTS/NODE/SUBNODES/NODE/PLAYLIST/ENTRY') do |e|
      primary_keys.push(e.elements["PRIMARYKEY"].attributes["KEY"])
    end

    playlists = []
    playlist_xml.elements.each('NML/COLLECTION/ENTRY') do |e|
      playlist = {}
      playlist[:TITLE] = e.attributes["TITLE"]
      playlist[:ARTIST] = e.attributes["ARTIST"]
      playlist[:ALBUM] = {}
      playlist[:ALBUM][:TITLE] = e.elements["ALBUM"].attributes["TITLE"]
      playlist[:ALBUM][:OF_TRACKS] = e.elements["ALBUM"].attributes["OF_TRACKS"]
      playlist[:ALBUM][:TRACK] = e.elements["ALBUM"].attributes["TRACK"]
      playlist[:TEMPO] = e.elements["TEMPO"].attributes["BPM"]
      playlist[:KEY] = e.elements["MUSICAL_KEY"].attributes["VALUE"]
      playlist[:PATH] = e.elements["LOCATION"].attributes["VOLUME"] +
                        e.elements["LOCATION"].attributes["DIR"] +
                        e.elements["LOCATION"].attributes["FILE"]
      Amazon::Ecs.debug = true
      sleep(10)
      amz_search_results = Amazon::Ecs.item_search(
        playlist[:TITLE] + playlist[:ARTIST], # キーワード
        search_index: 'MP3Downloads', # 検索対象の設定
        dataType: 'script',
        responce_group: 'Small',
        country:  'jp'
      )
      unless amz_search_results.items.empty? then
        playlist[:AMZ_URL] = amz_search_results.items[0].get('DetailPageURL')
      end
      playlists.push(playlist)
    end

    @content[:playlist] = []
    primary_keys.each do |key|
      playlists.each do |playlist|
        if playlist[:PATH] == key then
          @content[:playlist].push(playlist)
          break;
        end
      end
    end
  end

end
