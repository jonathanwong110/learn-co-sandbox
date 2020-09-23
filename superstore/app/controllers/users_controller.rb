class UsersController < ApplicationController
  
  get '/signup' do
    erb :'/users/signup'
  end
  
  post '/signup' do
    @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password], :location => params[:location])
    if @user.save && @user.username != "" && @user.email != ""
      session[:user_id] = @user.id
      flash[:message] = "*Sign Up is successful*"
      redirect "/users/#{current_user.id}"
    elsif params[:username].empty?
      flash[:error] = "*Please enter a username*"
      redirect '/signup'
    elsif params[:password].empty?
      flash[:error] = "*Please enter a password*"
      redirect '/signup'
    elsif params[:email].empty?
      flash[:error] = "*Please enter an email*"
      redirect '/signup'
    elsif params[:location].empty?
      flash[:error] = "*Please enter a location*"
      redirect '/signup'
    else params[:username] == User.find_by(:username => params[:username])
      flash[:error] = "*Username already exists. Choose another username*"
      redirect '/signup'
    end
  end

  get '/login' do
    if !is_logged_in?
      erb :'/users/login'
    end
  end
  
  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/#{current_user.id}"
    elsif params[:username].empty?
      flash[:error] = "*Please enter a username*"
      redirect '/login'
    elsif params[:password].empty?
      flash[:error] = "*Please enter a password*"
      redirect '/login'
    else
      flash[:error] = "*Incorrect username and/or password*"
      redirect '/login'
    end
  end

  get '/logout' do
    if is_logged_in?
      session.clear
      redirect '/'
    end
  end
  
  get '/users' do
    if is_logged_in?
      @users = User.all
      erb :'/users/users'
    else
      redirect '/login'
    end
  end
  
  get '/users/:id' do
    if is_logged_in?
      @user = User.find(params[:id])
      @items = @user.items
      erb :'/users/show_user'
    else
      redirect '/login'
    end
  end
  
  get '/users/:id/edit' do
    @user = User.find(params[:id])
    if is_logged_in? && @user.id == current_user.id
      @user.save
      erb :'/users/edit_user'
    else
      redirect "/users/#{@user.id}"
    end
  end
  
  patch '/users/:id/edit' do
    @user = User.find(params[:id])
     if !params[:email].empty? && !params[:password_digest].empty? && !params[:location].empty?
      @user.update(:email => params[:email], :password => params[:password_digest], :location => params[:location])
      @user.save
      flash[:message] = "*Update is successful*"
      redirect "/users/#{@user.id}"
     elsif params[:email].empty?
      flash[:error] = "*Please enter an email*"
     elsif params[:location].empty?
      flash[:error] = "*Please enter a location*"
      redirect "/users/#{@user.id}/edit"
     elsif params[:password_digest].empty?
      flash[:error] = "*Please enter a password*"
      redirect "/users/#{@user.id}/edit"
     else params[:location].empty?
      flash[:error] = "*Please enter a location*"
      redirect "/users/#{@user.id}/edit"
    end
  end
  
end