require 'rexml/document'

module ImportPlaylistService
  class ImportNml
    attr_reader :upload_file

    def initialize(upload_file)
      @upload_file = upload_file
    end

    def execute
      songs = []
      get_songs_from_xml.each do |data|
        artist_id = findOrCreateArtist(data[:ARTIST_NAME]).id
        title = data[:TITLE]
        song = Song.find_by(artist_id: artist_id, title: title)
        unless song then
          song = Song.create(artist_id: artist_id, title: title)
        end
        songs.push(song)
      end
      AmazonJob.perform_later(songs)
      return songs
    end

    private
      def get_songs_from_xml
        orders = []
        xml.elements.each('NML/PLAYLISTS/NODE/SUBNODES/NODE/PLAYLIST/ENTRY') do |e|
          orders.push(e.elements["PRIMARYKEY"].attributes["KEY"])
        end

        elements = []
        xml.elements.each('NML/COLLECTION/ENTRY') do |e|
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

    private
      def findElement(order_key, elements)
        elements.each do |element|
          if element[:PATH] == order_key then
            return element
          end
        end
      end

    private
      def findOrCreateArtist(artist_name)
        Artist.find_by(artist_name: artist_name) || Artist.create(artist_name: artist_name)
      end

    private
      def file_name
        upload_file.original_filename
      end

    private
      def xml
        @xml || @xml = REXML::Document.new(open(upload_file))
      end
  end
end
