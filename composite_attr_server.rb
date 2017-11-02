require 'sinatra/base'
require "sinatra/activerecord"
require 'sinatra/config_file'
require 'uri'
require 'active_support/all'
require 'rest-client'
require 'redis'
require 'forwardable'
require 'celluloid'
require_relative 'lib/server'
require 'jwt'
require_relative 'jwt_auth'


class Public < Sinatra::Base
  register Sinatra::ConfigFile
  use JwtAuth
  set :bind, '0.0.0.0'
  set :port, 4571
  config_file 'config/config.yaml'

  configure do
    set :redis_client, RedisCache.new(Redis.new(
        :host => self.send(ENV['RACK_ENV'])['redis_host'], :db => 3))
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
  end


  post '/product/:sku/where_used/' do
    scopes, customer = request.env.values_at :scopes, :customer
    settings.where_used_reader.get_where_used_attribute(params[:sku], customer['group'])
  end

  get '/product/:sku/bom/' do
    scopes, customer = request.env.values_at :scopes, :customer
    settings.bom_reader.get_bom_attribute params[:sku], customer['group']
  end


  get '/product/:sku/interchanges/' do
    settings.interchange_reader.get_interchange_attribute params[:sku]
  end


  get '/product/:sku/sales_notes/' do
    settings.sales_note_getter.get_sales_note_attribute params[:sku]
  end


  get '/product/:sku/kit_matrix/' do
    settings.kit_matrix_getter.get_kit_matrix_attribute params[:sku]
  end

  get '/product/:sku/service_kits/' do
    scopes, customer = request.env.values_at :scopes, :customer
    settings.service_kit_getter.get_service_kit_attribute params[:sku], customer['group']
  end

  get '/product/:sku/major_components/' do
    scopes, customer = request.env.values_at :scopes, :customer
    settings.bom_reader.get_major_component params[:sku], customer['group']
  end

  get '/product/:sku/gasket_kit/' do
    scopes, customer = request.env.values_at :scopes, :customer
    settings.gasket_kit_getter.get_gasket_kit_attribute params[:sku], customer['group']
  end

  get '/product/:sku/gasket_turbo/' do
    scopes, customer = request.env.values_at :scopes, :customer
    settings.gasket_turbo_getter.get_gasket_turbo_attribute params[:sku], customer['group']
  end

  post '/product/sales_notes/' do
    skus = JSON.parse(request.body.read)
    settings.sales_notes_batch_getter.get_sales_note_attributes skus
  end

  get '/product/:sku/standard_oversize/' do
    settings.standard_oversize_getter.get_standard_oversize params[:sku]
  end

  after do
    response.body = JSON.dump(response.body)
  end

end