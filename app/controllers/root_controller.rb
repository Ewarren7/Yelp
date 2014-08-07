class RootController < ApplicationController
  
  post '/go' do
    @lat = params[:lat]
    @lon = params[:lon]
    puts "#{@lat}, #{@lon}"
    YelpBiz.set_location(@lat, @lon)
    make_bizs
    puts "all_open length = #{YelpBiz.all_open.uniq.length}"
    @all_open = YelpBiz.all_open.uniq
 
    erb :index  
  end

  get '/' do
    erb :location
  end



end
