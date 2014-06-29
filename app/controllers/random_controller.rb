class RandomController < ApplicationController
  
  get '/random' do
    i=0
    random_open = YelpBiz.all_open.shuffle
    @random_biz = random_open[i]
    i+=1
    erb :random
  end

end