require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if session[:user_id]
      redirect to '/tweets'
    else
    erb :'/users/create_user'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect to '/signup'
    else
    @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
    session[:user_id] = @user.id
    redirect to '/tweets'
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/tweets'
    else
    erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params["username"])
    session[:user_id] = @user.id 
    redirect to '/tweets'
  end
  
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end
  
  get '/tweets/new' do
    if logged_in?
    erb :'/tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets' do
    if logged_in?
    @user = User.find_by(:id => session[:user_id])
    erb :'/tweets/tweets'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if params[:content].empty?
      redirect to '/tweets/new'
    else
      @tweet = Tweet.create(:content => params["content"])
      @tweet.user_id = session[:user_id]
      @tweet.save
      
    erb :'/tweets/show_tweet'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/login'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
    @tweet = Tweet.find_by(:id => params[:id])
    erb :'/tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
    @tweet = Tweet.find_by(:id => params[:id])
    erb :'/tweets/edit_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets/:id' do
    if !params[:content].empty?
      @tweet = Tweet.find_by(:id => params[:id])
      @tweet.content = params[:content]
      @tweet.save
    erb :'/tweets/show_tweet'
    else
      @tweet = Tweet.find_by(:id => params[:id])
      redirect to "/tweets/#{@tweet.id}/edit"
    end
  end

  post '/tweets/:id/delete' do
    @tweet = Tweet.find_by(:id => params[:id])
    if logged_in? && @tweet.user_id == session[:user_id]
    @tweet.destroy
    else
      redirect to '/login'
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end

end
