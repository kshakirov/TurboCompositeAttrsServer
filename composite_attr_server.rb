require 'sinatra'
require "sinatra/activerecord"
require 'uri'
require 'active_support/all'
require 'rest-client'
require_relative 'lib/server'

set :bind, '0.0.0.0'
set :port, 4571

configure do
  set :compose_attr_reader, CompositAttrsReader.new
end



get '/product/:sku' do
  response = settings.compose_attr_reader.get_all_composite_attrs params[:sku]
  response.to_json
end