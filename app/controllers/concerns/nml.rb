require 'rexml/document'

module Nml
  extend ActiveSupport::Concern
  included do
    # code ...cal
    # ここにコールバック入れる
  end

  # instance methods go here
  # def instance_method
  #
  # end
  def importSongsFromNml(nml_file)
    playlist_xml = REXML::Document.new(open(nml_file))

    orders = []
    playlist_xml.elements.each('NML/PLAYLISTS/NODE/SUBNODES/NODE/PLAYLIST/ENTRY') do |e|
      orders.push(e.elements["PRIMARYKEY"].attributes["KEY"])
    end

    elements = []
    playlist_xml.elements.each('NML/COLLECTION/ENTRY') do |e|
      element = {}
      element[:TITLE] = e.attributes["TITLE"]
      element[:ARTIST_NAME] = e.attributes["ARTIST"]
      element[:ALBUM_TITLE] = e.elements["ALBUM"].attributes["TITLE"]
      element[:TEMPO] = e.elements["TEMPO"].attributes["BPM"]
      element[:MUSICAL_KEY] = e.elements["MUSICAL_KEY"].attributes["VALUE"]
      element[:PATH] = e.elements["LOCATION"].attributes["VOLUME"] +
                        e.elements["LOCATION"].attributes["DIR"] +
                        e.elements["LOCATION"].attributes["FILE"]
      elements.push(element)
    end

    result = []
    orders.each do |order_key|
      result.push(findElement(order_key, elements))
    end

    return result
  end

  def findElement(order_key, elements)
    elements.each do |element|
      if element[:PATH] == order_key then
        return element
      end
    end
  end

  module ClassMethods
    # static methods go here
    # def static_method
    #
    # end
  end
end
