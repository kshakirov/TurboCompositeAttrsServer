require 'rest-client'
require 'forwardable'
require 'celluloid/current'
require 'celluloid/pool'
require 'timers'
require 'redis'
require 'composite_primary_keys'
require 'logger'
require_relative "../lib/server.rb"
configuration = YAML::load(IO.read(__dir__ + '/price/database.yml'))
@connection = ActiveRecord::Base.establish_connection(configuration[ENV['RACK_ENV']])
@connection.checkout_timeout = 10
@logger = Logger.new(__dir__ + '../../logs/cron.log')
@logger.level =Logger::INFO