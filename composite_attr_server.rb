require 'sinatra'
require "sinatra/activerecord"
require 'uri'
require 'active_support/all'
require 'rest-client'
require 'redis'
require 'forwardable'
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
set :gasket_kit_getter, GasketKitGetter.new(settings.redis_client)
set :gasket_turbo_getter, GasketTurboGetter.new(settings.redis_client)
set :sales_notes_batch_getter, SalesNoteBatchGetter.new(settings.redis_client)
set :standard_oversize_getter, StandardOversizeGetter.new(settings.redis_client)


post '/product/:sku/where_used/' do
  sku = params[:sku]
  id = JSON.parse(request.body.read)
  response = settings.where_used_reader.get_where_used_attribute(sku,id[0])
  response.to_json
end

get '/product/:sku/bom/' do
  response = settings.bom_reader.get_bom_attribute params[:sku], params[:stats]
  response.to_json
end


get '/product/:sku/interchanges/' do
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

get '/product/:sku/service_kits/' do
  response = settings.service_kit_getter.get_service_kit_attribute params[:sku], params[:stats]
  response.to_json
end

get '/product/:sku/major_components/' do
  response = settings.bom_reader.get_major_component params[:sku], params[:stats]
  response.to_json
end

get '/product/:sku/gasket_kit/' do
  response = settings.gasket_kit_getter.get_gasket_kit_attribute params[:sku], params[:stats]
  response.to_json
end

get '/product/:sku/gasket_turbo/' do
  response = settings.gasket_turbo_getter.get_gasket_turbo_attribute params[:sku], params[:stats]
  response.to_json
end

post '/product/sales_notes/' do
  skus = JSON.parse(request.body.read)
  response = settings.sales_notes_batch_getter.get_sales_note_attributes skus
  response.to_json
end

get '/product/:sku/standard_oversize/' do
  response = settings.standard_oversize_getter.get_standard_oversize params[:sku]
  response.to_json
end

