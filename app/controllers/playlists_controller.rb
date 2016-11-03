class PlaylistsController < ApplicationController
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

    import_nml_service = ImportPlaylistService::ImportNml.new(send_params[:upload_file])
    songs = import_nml_service.execute

    if @playlist.save then
      songs.each do |song|
        unless @playlist.playlist_items.build(playlist_id: @playlist.id, song_id: song.id).save then
          redirect_to root_path
        end
      end
      redirect_to :action => 'show', :id => @playlist.id
    else
      redirect_to root_path
    end
  end

  private
    def send_params
      params.require(:content).permit(:upload_file, :title, :remarks)
    end
end
