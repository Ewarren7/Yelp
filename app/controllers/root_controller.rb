class RootController < ApplicationController
  
  get '/' do
    
    make_bizs (true)
    @all_open = YelpBiz.all_open
    binding.pry
    erb :index  

  end



end
