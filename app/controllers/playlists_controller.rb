class PlaylistsController < ApplicationController
  include Nml

  def index
  end

  def show
    @playlist = Playlist.find_by(id: params[:id])
  end

  def create
    @playlist = Playlist.new(
      user_id: send_params[:user_id],
      file_name: send_params[:upload_file].original_filename,
      title: send_params[:title],
      file_type: 1,
      # Traktor以外のプレイリストを読み込むようになったとき、
      # これが活きてくる
      remarks: send_params[:remarks])

    import_nml_service = ImportPlaylistService::ImportNml.new(
      {playlist_id: @playlist.id,
       upload_file: send_params[:upload_file],
       user_id: nil})
    song_params = import_nml_service.execute

    if @playlist.save then
      song_params.each do |param|
        unless @playlist.songs.build(param).save then
          redirect_to root_path
        end
      end
      check_amz_mp3_url(@playlist.songs)
      redirect_to :action => 'show', :id => @playlist.id
    else
      redirect_to root_path
    end
  end

  private
    def check_amz_mp3_url(songs)
      params = []
      songs.each do |song|
        param = {}
        param[:SONG_ID] = song.id
        param[:KEYWORD] = song.artist.artist_name + ' ' + song.title
        params.push(param)
      end
      # AmazonJob.perform_later(params)
    end

  private
    def send_params
      params.require(:content).permit(:upload_file, :title, :remarks)
    end
end
