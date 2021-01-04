class FavoriteBooksController < ApplicationController

  # restful routing override methods

  def update
    begin
      FavoriteBook.find(params[:id]).update(object_params)
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ['Something went wrong...']
    end

    flash[:success] = ['Favorite Book Notes Updated']
    redirect_to user_path(params[:user_id])
  end

  # processing methods 
  
  protected

    def object_params
      params.require(:favorite_book).permit([:notes])
    end

end
