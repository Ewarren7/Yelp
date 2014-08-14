class ApplicationController < Sinatra::Base

  set :views, File.expand_path('../../views', __FILE__)
  # rvmsudo rackup -p 80 to start on port 80

  configure :development do
    register Sinatra::Reloader
  end
end
