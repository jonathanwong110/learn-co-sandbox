require 'rack-flash'

class ApplicationController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    use Rack::Flash, :sweep => true
    enable :sessions
    set :session_secret, "secret"
  end
  
  get '/' do
    if is_logged_in?
      redirect "/login"
    else
      erb :index
    end
  end
  
  helpers do
    
    def is_logged_in?
      !!session[:user_id]
    end
    
    def current_user
      User.find(session[:user_id])
    end
    
    def redirect_if_not_logged_in
      if !session[:user_id]
        redirect '/login'
      end
    end
      
  end
  
end