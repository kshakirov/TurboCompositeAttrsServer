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

unless ENV['RACK_ENV']
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

configuration = YAML::load(IO.read(__dir__ + '/../config/database.yml'))
@connection = ActiveRecord::Base.establish_connection(configuration[ENV['RACK_ENV']])
@connection.checkout_timeout = 60

###########       AUXILIARY

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
  unresolved_futures.size == 0
end

def make_batch_future id, worker
  worker.future.set_attribute(id)
end

def stage_body group, worker, stage_name
  futures = []
  ids = group.map do |part|
    futures.push make_batch_future(part.id, worker)
    part.id
  end
  puts "#{stage_name} Stage  Ids   => " + ids.join(",")
  initial_size = futures.size
  until are_futures_ready?(futures, initial_size)
    futures = remove_resolved_futures futures
  end
end

def stage_bulk_body groups, worker, stage_name
  futures = []
  groups.each_slice(100) do |group|
    ids = group.map {|p| p.id}
    futures.push make_batch_future(ids, worker)
    puts "#{stage_name} Stage  Ids   => " + ids.join(",")
  end
  initial_size = futures.size
  until are_futures_ready?(futures, initial_size)
    futures = remove_resolved_futures futures
  end
end