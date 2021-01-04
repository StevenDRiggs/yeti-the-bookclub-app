class BooksController < ApplicationController
  before_action :login_required, except: :object_params do
    define_variables
  end

  # processing methods 

  protected

    def object_params
      params.require(:book).permit([:name, :synopsis, author_ids: [], genre_ids: [], authors_attributes: [:name], genres_attributes: [:name]])
    end

end
