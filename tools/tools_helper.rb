require 'sinatra'
require "sinatra/activerecord"
require 'rest-client'
require_relative  "../lib/server.rb"
require_relative "../lib/src/tools/attributes_cacher"
require_relative "../lib/src/tools/price_cacher"
require_relative  "../lib/src/tools/products_collection"
require 'redis'
require 'composite_primary_keys'
configuration = YAML::load(IO.read('database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])


