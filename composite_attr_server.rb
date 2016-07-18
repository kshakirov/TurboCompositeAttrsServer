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


get '/product/:sku/where_used/:group_id' do
  response = settings.compose_attr_reader.get_where_used_attribute params[:sku], params[:group_id]
  response.to_json
end

get '/product/:sku/bom/:group_id' do
  response = settings.compose_attr_reader.get_bom_attribute params[:sku], params[:group_id]
  response.to_json
end


get '/product/:sku/interchanges/:group_id' do
  response = settings.compose_attr_reader.get_interchange_attribute params[:sku], params[:group_id]
  response.to_json
end


get '/product/:sku/sales_notes/' do
  response = settings.compose_attr_reader.get_sales_notes params[:sku]
  response.to_json
end