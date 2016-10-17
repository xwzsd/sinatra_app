source "http://rubygems.org"

gem 'sinatra'
gem 'pry', '~> 0.10.4'
gem 'rake'
gem 'data_mapper'
gem 'dm-core'
gem 'dm-sqlite-adapter'
gem 'dm-timestamps'
gem 'dm-validations'
gem 'dm-aggregates'
gem 'dm-migrations'
gem 'haml'
gem 'aescrypt'
group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'rspec', :require => 'spec'
  gem 'rack-test'
end
