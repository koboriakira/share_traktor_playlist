class PlaylistsController < ApplicationController
  include Nml

  def index
  end

  def show
    @playlist = Playlist.find_by(id: params[:id])
  end

  def create
    #サービスクラス作って、処理をさせたいな〜
    @playlist = Playlist.new(
      file_name: 'test-file_name',
      title: file_params[:title],
      file_type: 1,
      remarks: 'test-remarks')
    @playlist.save

    songs = importSongsFromNml(file_params[:upload_file])
    @songs = []
    songs.each do |song|
      artist_id = findOrCreateArtistId(song[:ARTIST_NAME])
      @playlist.songs.build(playlist_id: @playlist.id,
                       title: song[:TITLE],
                       artist_id: artist_id)
    end
    if @playlist.save then
      redirect_to :action => 'show', :id => @playlist.id
    else
      redirect_to :action => 'new'
    end
  end



  private
    def findOrCreateArtistId(artist_name)
      artist = Artist.find_by(artist_name: artist_name)
      if artist then
        return artist.id
      else
        createArtist(artist_name)
      end
    end

  private
    def createArtist(artist_name)
      artist = Artist.new(artist_name: artist_name)
      if !artist.save then
        return artist.id
      else
        return nil
      end
    end

  private
    def file_params
      params.require(:content).permit(:upload_file, :title)
    end
end
