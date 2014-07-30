require 'bundler/setup'
Bundler.require
require'pry'
require 'open-uri'

#Dir[File.join(File.dirname(__FILE__), "./app/controllers", "*.rb")].each {|f| require f}

require './app/controllers/application_controller' 
require './app/controllers/random_controller' 
require './app/controllers/root_controller' 
require_relative 'run'