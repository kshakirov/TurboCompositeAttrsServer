require 'sinatra'
require "sinatra/activerecord"
require 'uri'
require 'active_support/all'
require 'rest-client'
require_relative 'lib/server'

set :bind, '0.0.0.0'
set :port, 4571


get '/product/:sku' do

end