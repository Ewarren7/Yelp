class RandomController < ApplicationController
  
  


  get '/random' do
    init_bizs (true) if YelpBiz.all == []
    @random_biz = YelpBiz.suffle_open
    #binding.pry
    erb :random
  end

end