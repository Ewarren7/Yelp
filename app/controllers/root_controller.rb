class RootController < ApplicationController
  
  post '/go' do
    @lat = params[:lat]
    @lon = params[:lon]
  
    YelpBiz.set_location(@lat, @lon)
    make_bizs
    @all_open = YelpBiz.all_open
 
    erb :index  
  end

  get '/' do
    erb :location
  end



end
