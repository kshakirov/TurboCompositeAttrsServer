require 'minitest'
require 'minitest/autorun'
require 'sinatra'
require "sinatra/activerecord"
require 'rest-client'
require_relative  "../lib/server.rb"
require 'redis'
require 'composite_primary_keys'
ENV['RACK_ENV'] = 'development'
configuration = YAML::load(IO.read(__dir__ + '/database.yml'))
ActiveRecord::Base.establish_connection(configuration[ENV['RACK_ENV']])