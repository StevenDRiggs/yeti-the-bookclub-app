class SessionsController < ApplicationController
  skip_before_action :define_variables
  before_action :login_required, only: [:destroy, :logout] 

  # restful routing override methods

  def create
    if params[:provider]
      @user = User.find_or_create_by_auth_hash(auth_hash)
      if @user.nil?
        flash[:errors] = ["Authentication error. Check that your name and email registered on #{params[:provider].capitalize} is not already registered on Yeti."]
        redirect_to login_path
      else
        session[:user_id] = @user.id

        redirect_to @user
      end
    else
      @user = User.find_by(name: params[:name_or_email])
      if @user.nil?
        @user = User.find_by(email: params[:name_or_email])
      end

      if @user.nil?
        flash[:errors] = ['User not found']
        redirect_to login_path
      elsif @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect_to @user
      else
        flash[:errors] = ['Password incorrect']
        redirect_to login_path
      end
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  def new
    render 'login'
  end

  # non-restful routing methods

  def logout
  end

  # processing methods 

  private

    def auth_hash
      request.env['omniauth.auth'][:extra][:raw_info]
    end

end
