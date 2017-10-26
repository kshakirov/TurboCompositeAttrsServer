require 'rest-client'
require 'forwardable'
require 'celluloid/current'
require 'celluloid/pool'
require 'timers'
require 'redis'
require 'composite_primary_keys'
require 'logger'
require_relative "../lib/server.rb"

def get_service_configuration
  service_configuration = YAML::load(IO.read((__dir__ + '/../config/config.yaml')))
  service_configuration[ENV['RACK_ENV']]['graphdb_service']
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

def are_futures_ready? unresolved_futures, initial_size, processing_time
  puts "Unresolved Futures [#{unresolved_futures.size}]"
  processed_futures = initial_size - unresolved_futures.size
  puts "Resolved [#{processed_futures}], Latency [#{processing_time.to_f/processed_futures}] "
  unresolved_futures.size == 0
end

configuration = YAML::load(IO.read(__dir__ + '/../config/database.yml'))
@connection = ActiveRecord::Base.establish_connection(configuration[ENV['RACK_ENV']])
