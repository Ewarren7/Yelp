class RootController < ApplicationController
  
  get '/' do
    erb :loading
    init_bizs (true)
    @all_open = YelpBiz.all_open
    erb :index  
  end



end
