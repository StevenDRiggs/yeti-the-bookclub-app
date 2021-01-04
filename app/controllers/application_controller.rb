class ApplicationController < ActionController::Base
  before_action :define_variables, only: [:create, :destroy, :edit, :index, :new, :show, :update, :delete]
  before_action :login_required, only: [:admin_or_self_required, :admin_required]

  helper_method :is_admin?
  
  # restful routing methods 

  def create
    @object_ = @obj.new(self.object_params)
    if @object_.save
      if @object_.is_a?(User)
        redirect_to @object_
      else
        redirect_to self.send("#{@obj.name.tableize}_path")
      end
    else
      flash[:errors] = @object_.errors.full_messages
      render :new
    end
  end

  def destroy
    begin
      object_ = @obj.find(params[:id])

      object_.destroy

      redirect_to self.send("#{@snake_case.pluralize}_path")
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ["#{@obj.name} not found"]
      redirect_to self.send("#{@snake_case.pluralize}_path")
    end
  end

  def edit
    begin
      @object_ = @obj.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ["#{@obj.name} not found"]
      redirect_to self.send("#{@snake_case.pluralize}_path")
    end
  end

  def index
    self.instance_variable_set('@objects', @obj.all)
  end

  def new
    @object_ = @obj.new
  end

  def show
    begin
      self.instance_variable_set("@#{@snake_case}", @obj.find(params[:id]))
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ["#{@obj.name} not found"]
      redirect_to self.send("#{@snake_case.pluralize}_path")
    end
  end

  def update
    begin
      @object_ = self.instance_variable_set("@#{@snake_case}", @obj.find(params[:id]))
      if @object_.update(self.object_params)
        redirect_to @object_
      else
        flash[:errors] = @object_.errors.full_messages
        render :edit
      end
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ["#{@obj.name} not found"]
      redirect_to self.send("#{@snake_case.pluralize}_path")
    end
  end

  # non-restful routing methods 

  def delete
    begin
      object_ = self.instance_variable_set("@#{@snake_case}", @obj.find(params[:id]))
    rescue ActiveRecord::RecordNotFound
      flash[:errors] = ["#{@obj.name} not found"]
      redirect_to self.send("#{@snake_case.pluralize}_path")
    end
  end

  def welcome
    if session[:user_id]
      redirect_to user_path(session[:user_id])
    end
  end

  # processing methods 

  protected

    def admin_or_self_required
      user_id = params[:user_id].nil? ? params[:id] : params[:user_id]
      user_id = user_id.to_i if user_id

      unless user_id && user_id == session[:user_id] || is_admin?
        flash[:errors] = ["You must be logged in with admin privileges to view or edit other users' information"]
        redirect_to root_path
      end
    end

    def admin_required
      user_id = params[:user_id].nil? ? params[:id] : params[:user_id]

      unless user_id && is_admin?
        flash[:errors] = ['You must be logged in with admin priveleges to view this page']
        redirect_to root_path
      end
    end

    def define_variables
      @obj = Object.const_get(self.class.to_s[0..-11].singularize)
      @snake_case = @obj.to_s.underscore
    end

    def is_admin?
      begin
        user = User.find(session[:user_id])

        user.admin
      rescue ActiveRecord::RecordNotFound
        false
      end
    end

    def login_required
      if !session[:user_id]
        flash[:errors] = ['You must be logged in to view this page']
        redirect_to root_path
      end
    end

end
