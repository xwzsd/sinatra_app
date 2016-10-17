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
          :url_base => "https://secret-scrubland-67713.herokuapp.com/"
        )

  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

configure :development do
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/shorturls.db")
end

configure :production do
  DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_COPPER_URL'])
end

end
