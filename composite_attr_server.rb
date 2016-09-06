require 'sinatra'
require "sinatra/activerecord"
require 'uri'
require 'active_support/all'
require 'rest-client'
require 'redis'
require_relative 'lib/server'

set :bind, '0.0.0.0'
set :port, 4571

set :redis_client, RedisCache.new(Redis.new(:host => "redis", :db => 3))
set :where_used_reader, WhereUsedGetter.new(settings.redis_client)
set :bom_reader, BomGetter.new(settings.redis_client)
set :interchange_reader, InterchangeGetter.new(settings.redis_client)
set :kit_matrix_getter, KitMatrixGetter.new(settings.redis_client)
set :service_kit_getter, ServiceKitGetter.new(settings.redis_client)
set :sales_note_getter, SalesNoteGetter.new(settings.redis_client)


get '/product/:sku/where_used/:group_id' do
  response = settings.where_used_reader.get_where_used_attribute params[:sku], params[:group_id]
  response.to_json
end

get '/product/:sku/bom/:group_id' do
  response = settings.bom_reader.get_bom_attribute params[:sku], params[:group_id]
  response.to_json
end


get '/product/:sku/interchanges/:group_id' do
  response = settings.interchange_reader.get_interchange_attribute params[:sku]
  response.to_json
end


get '/product/:sku/sales_notes/' do
  response = settings.sales_note_getter.get_sales_note_attribute params[:sku]
  response.to_json
end


get '/product/:sku/kit_matrix/' do
  response = settings.kit_matrix_getter.get_kit_matrix_attribute params[:sku]
  response.to_json
end

get '/product/:sku/service_kits/:group_id' do
  response = settings.service_kit_getter.get_service_kit_attribute params[:sku], params[:group_id]
  response.to_json
end

get '/product/:sku/major_components/:group_id' do
  response = settings.bom_reader.get_major_component params[:sku], params[:group_id]
  response.to_json
end



