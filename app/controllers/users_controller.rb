class UsersController < ApplicationController
  
  get '/' do
    binding.pry
    erb :'users/index'
  end

  get '/signup' do
    erb :'/users/signup'
  end

  post '/signup' do
    @user = User.new(:username => params[:user][:username], :email => params[:user][:email], :password => params[:user][:password])
    @user.save
    session[:user_id] = @user.id
    redirect '/users/account'
  end

  get 'login' do
    erb :'users/login'
  end

  post '/login' do
    @user = User.find_by(:username => params[:username], :password => params[:password])
    
    if @user
      session[:user_id] = @user.id
      redirect '/account'
    end
    erb :'users/error'
  end

  get '/account' do
    @user = User.find_by_id(session[:user_id])
    
    if @user
      erb :'users/account'
    else
      erb :'users/error'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
