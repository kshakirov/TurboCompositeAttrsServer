require 'minitest'
require 'minitest/autorun'
require 'sinatra'
require "sinatra/activerecord"
require 'rest-client'
require_relative "../lib/server.rb"
require 'redis'
require 'composite_primary_keys'
ENV['RACK_ENV'] = 'development'
configuration = YAML::load(IO.read(__dir__ + '/../config/database.yml'))
ActiveRecord::Base.establish_connection(configuration[ENV['RACK_ENV']])


def get_service_configuration
  service_configuration = YAML::load(IO.read((__dir__ + '/../config/config.yaml')))
  service_configuration[ENV['RACK_ENV']]['graphdb_service']
end