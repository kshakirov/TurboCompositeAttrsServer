require 'sinatra'
require "sinatra/activerecord"
require 'rest-client'
require 'forwardable'
require_relative  "../lib/server.rb"
require_relative "../lib/src/tools/attributes_cacher"
require_relative "../lib/src/tools/price_cacher"
require_relative "../lib/src/tools/kit_matrix_cacher"
require_relative "../lib/src/tools/gasket_kit_cacher"
require_relative  "../lib/src/tools/products_collection"
require_relative  "../lib/src/tools/secondary_attrs_cacher"
require_relative  "../lib/src/tools/standard_oversize_cacher"
require 'redis'
require 'composite_primary_keys'
require 'logger'
configuration = YAML::load(IO.read(__dir__ + '/database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])
@logger = Logger.new(__dir__ + '/../logs/cron.log')
@logger.level =Logger::INFO


