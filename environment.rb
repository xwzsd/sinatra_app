require 'rubygems'
require 'bundler/setup'
require 'data_mapper'
require 'json'
require 'ostruct'
require 'rake'

require 'sinatra' unless defined?(Sinatra)

configure do

  SiteConfig = OpenStruct.new(
          :title => 'Sinatra_app',
          :author => 'Your Name Can Go Here',
          :url_base => "http://localhost:4567/"
        )

  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/shorturls.db")

end
