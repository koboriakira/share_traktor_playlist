class PlaylistsController < ApplicationController
  def index
  end

  def show
    @playlist = Playlist.find_by(id: params[:id])
  end

  def create
    if (send_params[:upload_file].nil? || send_params[:title].blank?) then
      render plain: 'プレイリストのタイトルが空白、またはファイルが指定されていません。'
      return
    end
    tmp = send_params[:upload_file].original_filename.split('.')
    file_ext = tmp[tmp.length - 1]
    if file_ext != 'nml' then
      render plain: 'プレイリストのファイルの拡張子が"nml"ではありません。'
      return
    end
    import_nml_service = ImportPlaylistService::ImportNml.new(send_params[:upload_file])
    songs = import_nml_service.execute
    AmazonJob.perform_later # Amazonアフェリエイト連携

    @playlist = Playlist.new(
      user_id: send_params[:user_id],
      file_name: send_params[:upload_file].original_filename,
      title: send_params[:title],
      file_type: 1,
      # Traktor以外のプレイリストを読み込むようになったとき、
      # これが活きてくる
      remarks: send_params[:remarks])

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
