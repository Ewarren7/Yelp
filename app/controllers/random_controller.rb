class RandomController < ApplicationController
  
  get '/random' do
    make_bizs () if YelpBiz.all == []
    @random_biz = YelpBiz.suffle_open
    #binding.pry
    erb :random
  end

end