class RootController < ApplicationController
  
  get '/' do
    @all_open = YelpBiz.all_open
    erb :index
  end



end
