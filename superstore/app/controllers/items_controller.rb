class ItemsController < ApplicationController
  
    #def redirect_if_not_logged_in
    #  if !session[:user_id]
    #    redirect '/login'
    #  end
    #end

  get '/items' do
    redirect_if_not_logged_in
      @items = Item.all
      erb :'/items/items'
  end
  
  get '/items/new' do
    if is_logged_in?
      erb :'/items/new'
    else
      redirect '/login'
    end
  end
  
  post '/items' do
    redirect_if_not_logged_in
    if params[:title].empty? || params[:price].empty? || params[:description].empty?
      if params[:title].empty?
          flash[:error] = "*Please enter a title*"
      elsif params[:price].empty?
          flash[:error] = "*Please enter a price*"
      else params[:description].empty?
          flash[:error] = "*Please enter a description*"
      end
        redirect '/items/new'
    else
      @item = Item.new(:title => params[:title], :price => params[:price], :description => params[:description], :user_id => session[:user_id])
      if @item.save
        flash[:message] = "*Creation of #{@item.title.capitalize} is successful*"
        redirect "/items/#{@item.id}"
      end
    end
  end
  
  get '/items/:id' do
    if is_logged_in?
      @item = Item.find(params[:id])
      erb :'/items/show_item'
    else
      redirect '/login'
    end
  end
  
  get '/items/:id/edit' do
    @item = Item.find(params[:id])
    if is_logged_in? && @item.user_id == current_user.id
      @item.save
      erb :'/items/edit_item'
    else
      redirect "/items/#{@item.id}"
    end
  end
  
  patch '/items/:id/edit' do
    @item = Item.find(params[:id])
    if @item.user_id != current_user.id
      redirect "/items/#{@item.id}"
    end
    @item = Item.find(params[:id])
     if !params[:title].empty? && !params[:price].empty? && !params[:description].empty?
      @item.update(:title => params[:title], :price => params[:price], :description => params[:description])
      @item.save
      flash[:message] = "*Edit successful*"
      redirect "/items/#{@item.id}"
     elsif params[:title].empty?
      flash[:error] = "*Please enter a title*"
      redirect "/items/#{@item.id}/edit"
     elsif params[:price].empty?
      flash[:error] = "*Please enter a price*"
      redirect "/items/#{@item.id}/edit"
     else params[:description].empty?
      flash[:error] = "*Please enter a description*"
      redirect "/items/#{@item.id}/edit"
    end
  end

  post '/items/:id/delete' do
    @item = Item.find(params[:id])
    if is_logged_in?
      if @item.user_id == current_user.id
        @item.delete
        flash[:message] = "*Deletion of #{@item.title.capitalize} is successful*"
        redirect '/items'
      else
        redirect '/items'
      end
    else
      redirect "/login"
    end
  end
  
end