class DownloadsController < ApplicationController
  def index
    @downloads = current_user.downloads.paginate(page: params[:page], per_page: params[:per_page])
  end

  def destroy
    download = current_user.downloads.find(params[:id])

    download.destroy

    redirect_to downloads_path
  end

  def download
    download = current_user.downloads.find(params[:id])

    send_file(
      download.url,
      filename: "#{ download.title.downcase.gsub(" ", "_") }.cbr",
      type: "application/x-cbr"
    )
  end
end
