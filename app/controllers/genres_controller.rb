class GenresController < ApplicationController
  before_action :login_required, except: :object_params do
    define_variables
  end

  # processing methods 

  protected

    def object_params
      params.require(:genre).permit([:name, book_ids: [], books_attributes: [:name]])
    end

end
