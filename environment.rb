require 'bundler/setup'
Bundler.require

require 'open-uri'

Dir[File.join(File.dirname(__FILE__), "./app/controllers", "*.rb")].each {|f| require f}

require_relative 'run'