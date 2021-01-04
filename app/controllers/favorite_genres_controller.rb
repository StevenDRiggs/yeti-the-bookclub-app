class FavoriteGenresController < ApplicationController

  # restful routing override methods

  def update
    begin
      FavoriteGenre.find(params[:id]).update(object_params)
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ['Something went wrong...']
    end

    flash[:success] = ['Favorite Genre Notes Updated']
    redirect_to user_path(params[:user_id])
  end

  # processing methods 

  protected

    def object_params
      params.require(:favorite_genre).permit([:notes])
    end

end
