require 'rest-client'
require 'forwardable'
require 'celluloid/current'
require 'celluloid/pool'
require 'timers'
require 'redis'
require 'composite_primary_keys'
require 'logger'
require_relative "../lib/server.rb"
ENV['RACK_ENV'] = 'development'
configuration = YAML::load(IO.read(__dir__ + '/../config/database.yml'))
@connection = ActiveRecord::Base.establish_connection(configuration[ENV['RACK_ENV']])
@connection.checkout_timeout = 10
@logger = Logger.new(__dir__ + '../../logs/cron.log')
@logger.level =Logger::INFO

def get_service_configuration
  service_configuration = YAML::load(IO.read((__dir__ + '/../config/config.yaml')))
  service_configuration[ENV['RACK_ENV']]['graphdb_service']
end