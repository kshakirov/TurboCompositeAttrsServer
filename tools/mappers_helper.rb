require 'rest-client'
require 'forwardable'
require 'celluloid/current'
require 'celluloid/pool'
require 'timers'
require 'redis'
require 'composite_primary_keys'
require 'logger'
require 'time_difference'
require_relative "../lib/server.rb"


unless  ENV['RACK_ENV']
  puts "SET RACK_ENV = [production,development,staging,test]  then try again .."
  exit(1)
end

def get_service_configuration
  service_configuration = YAML::load(IO.read((__dir__ + '/../config/config.yaml')))
  service_configuration[ENV['RACK_ENV']]['graphdb_service']
end


def get_redis_host
  redis_configuration = YAML::load(IO.read((__dir__ + '/../config/config.yaml')))
  redis_configuration[ENV['RACK_ENV']]['redis_host']
end

def make_future id, worker
  worker.future.set_attribute(id)
end

def map_specific_parts worker
  Part.all.map do |part|
    puts "Created Future for [#{part.id}]"
    make_future(part.id, worker)
  end
end

def remove_resolved_futures futures
  futures.select do |future|
    if future.ready?
      future.value
      false
    else
      true
    end
  end
end

def are_futures_ready? unresolved_futures, initial_size
  #puts "Unresolved Futures [#{unresolved_futures.size}]"
  #processed_futures = initial_size - unresolved_futures.size
  #puts "Resolved Futures [#{processed_futures.size}]"
  unresolved_futures.size == 0
end

configuration = YAML::load(IO.read(__dir__ + '/../config/database.yml'))
@connection = ActiveRecord::Base.establish_connection(configuration[ENV['RACK_ENV']])
@connection.checkout_timeout = 60

