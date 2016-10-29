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

    elements = []
    playlist_xml.elements.each('NML/COLLECTION/ENTRY') do |e|
      element = {}
      element[:PLAYLIST_ID] = playlist_id
      element[:TITLE] = e.attributes["TITLE"]
      element[:ARTIST_NAME] = e.attributes["ARTIST"]
      artist = Artist.find_by(artist_name: element[:ARTIST_NAME])
      if artist then
        element[:ARTIST_ID] = artist.id
      else
        artist = Artist.new(artist_name: element[:ARTIST_NAME])
        if artist.save then
          element[:ARTIST_ID] = artist.id
        end
      end
      element[:ALBUM_TITLE] = e.elements["ALBUM"].attributes["TITLE"]
      element[:TEMPO] = e.elements["TEMPO"].attributes["BPM"]
      element[:KEY] = e.elements["MUSICAL_KEY"].attributes["VALUE"]
      element[:PATH] = e.elements["LOCATION"].attributes["VOLUME"] +
                        e.elements["LOCATION"].attributes["DIR"] +
                        e.elements["LOCATION"].attributes["FILE"]
      elements.push(element)
    end
    AmazonJob.perform_later(elements);



  end

end
