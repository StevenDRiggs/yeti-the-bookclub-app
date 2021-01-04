class UsersController < ApplicationController
  before_action :login_required, only: [:favorite, :unfavorite] 

  # restful routing override methods

  def create
    @object_ = @obj.new(self.object_params)
    if @object_.save
      session[:user_id] = @object_.id
      redirect_to @object_
    else
      flash[:errors] = @object_.errors.full_messages
      render :new
    end
  end

  # non-restful routing methods

  def favorite
    begin
      user = User.find(params[:user_id])
      class_ = params[:class_].constantize
      search_key = "#{params[:class_].underscore}_id".to_sym
      object_ = class_.find(params[:id])
      favorite_class = "Favorite#{params[:class_]}".constantize
      favorite_object = favorite_class.new(:user_id => user.id, search_key => object_.id)

      if favorite_object.save
        redirect_to self.send("#{params[:class_].tableize}_path")
      else
        raise ActiveRecord::RecordNotFound
      end
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ['Illegal operation performed']
      redirect_to root_path
    end
  end

  def unfavorite
    begin
      user = User.find(params[:user_id])
      class_ = params[:class_].constantize
      search_key = "#{params[:class_].underscore}_id".to_sym
      object_ = class_.find(params[:id])
      favorite_class = "Favorite#{params[:class_]}".constantize
      favorite_object = favorite_class.find_by(:user_id => user.id, search_key => object_.id)

      favorite_object.destroy

      redirect_to self.send("#{params[:class_].tableize}_path")
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ['Illegal operation performed']
      redirect_to root_path
    end
  end

  # processing methods 

  protected

    def object_params
      params.require(:user).permit([:name, :email, :password])
    end

end
