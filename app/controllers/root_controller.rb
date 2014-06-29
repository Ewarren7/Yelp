class RootController < ApplicationController
  
  post '/go' do
    
    @lat = params[:lat]
    @lon = params[:lon]
    binding.pry
    make_bizs (true)
    @all_open = YelpBiz.all_open
    binding.pry
    erb :index  

  end

  get '/' do

    erb :location
  end



end
