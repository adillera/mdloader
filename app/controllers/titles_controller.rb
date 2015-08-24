class TitlesController < ApplicationController
  def index
    @title = Title.new
    @titles = current_user.titles.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
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
  end

  private
  def permitted_data
    params[:title].permit(
      :name,
      :url
    )
  end
end
