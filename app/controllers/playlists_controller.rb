class PlaylistsController < ApplicationController
  def index
  end

  def show
    @playlist = Playlist.find_by(id: params[:id])
  end
end
