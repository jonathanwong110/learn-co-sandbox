class MessagesController < ApplicationController

  get '/messages' do
    if is_logged_in?
      @messages = Message.all
      erb :'/messages/messages'
    else
      redirect '/login'
    end
  end
  
  get '/messages/new' do
    if is_logged_in?
      erb :'/messages/new'
    else
      redirect '/login'
    end
  end
  
  post '/messages' do
    if is_logged_in?
      if params[:content].empty?
        flash[:error] = "*Please enter a message*"
        redirect '/messages/new'
      elsif params[:recipient].empty?
        flash[:error] = "*Please enter a recipient*"
        redirect '/messages/new'
      elsif
        @message = Message.new(:content => params[:content], :recipient => params[:recipient], :user_id => session[:user_id])
        if @message.save
          flash[:message] = "*Message was sent to #{@message.recipient}*"
          redirect "/messages/#{@message.id}"
        end
      end
    else
      redirect '/login'
    end
  end
  
  get '/messages/:id' do
    @message = Message.find(params[:id])
    if is_logged_in?
      if @message.user_id == current_user.id || @message.recipient == current_user.username
        @message = Message.find(params[:id])
        erb :'/messages/show_message'
      else
        redirect :'/messages'
      end
    else
      redirect '/login'
    end
  end

  post '/messages/:id/delete' do
    @message = Message.find(params[:id])
    if is_logged_in?
      if @message.user_id == current_user.id || @message.recipient == current_user.username
        @message.delete
        flash[:message] = "*Deletion of message was successful*"
        redirect '/messages'
      else
        redirect '/messages'
      end
    else
      redirect "/login"
    end
  end
  
end