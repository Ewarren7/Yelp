class ApplicationController < Sinatra::Base

  set :views, File.expand_path('../../views', __FILE__)

  configure :development do
    register Sinatra::Reloader
  end
end
