require 'minitest'
require 'minitest/autorun'
require 'sinatra'
require "sinatra/activerecord"
require 'rest-client'
require_relative  "../lib/server.rb"
require 'redis'
require 'composite_primary_keys'
configuration = YAML::load(IO.read('database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])