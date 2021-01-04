module SessionsHelper
  def oauth
    if !session[:user_id]
      render partial: 'sessions/oauth'
    else
      nil
    end
  end
end
