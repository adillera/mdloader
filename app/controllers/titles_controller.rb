class TitlesController < ApplicationController
  include MangaList

  def index
    @title = Title.new
    @titles = current_user.titles.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @title = current_user.titles.find(params[:id])
    @volumes = chapter_list.paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
  end

  def create
    begin
      current_user.titles.create(permitted_data)
      redirect_to titles_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
    begin
      title = current_user.titles.find(params[:id])

      title.destroy

      redirect_to titles_path
    end
  end

  def download
    Downloader.perform_async(params[:title], params[:url])

    redirect_to title_path(params[:id])
  end

  private
  def permitted_data
    params[:title].permit(
      :name,
      :url
    )
  end
end
