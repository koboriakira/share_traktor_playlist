class PlaylistsController < ApplicationController
  def index
  end

  def show
    @playlist = Playlist.find_by(id: params[:id])
  end

  def confirm
    #サービスクラス作って、処理をさせたいな〜
    #ImportNml.new(1).test
    nml = file_params[:upload_file];
    # @playlist = Playlist.new(file_name: nml..original_filename)
  end

  private
    def file_params
      params.require(:content).permit(:upload_file)
    end
end
