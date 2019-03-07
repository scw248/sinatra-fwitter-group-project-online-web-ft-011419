class TweetsController < ApplicationController
  get '/tweets/new' do 
    erb :'tweets/new'
  end

  post '/tweets' do
    @tweet = Tweet.new(params[:tweet])
    redirect to "tweets/#{@tweet.id}"
  end

  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    erb :'tweets/show'
  end

  get '/tweets/:id/edit' do
    erb :'tweets/edit'
  end 

  post '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    @tweet.update(params["tweet"])
    
    redirect to "tweets/#{@tweet.id}"
  end

  delete 'tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.delete
    redirect to '/tweets'
  end

end
