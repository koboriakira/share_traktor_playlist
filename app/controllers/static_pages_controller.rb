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
