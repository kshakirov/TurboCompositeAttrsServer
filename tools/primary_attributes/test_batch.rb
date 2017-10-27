require_relative '../mappers_helper'
require_relative 'worker_classes'

pool_size = 4
redis_host = get_redis_host
redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
graph_service_url = get_service_configuration
worker = PrimaryAttributeWorker.pool args: [redis_cache, graph_service_url]


def make_batch_future id, worker
  worker.future.set_attribute(id)
end


Part.find_in_batches(batch_size: 4).each do |group|
  futures = []
  puts "New Batch"
  group.map do |part|
    puts "#{part.id}"
    futures.push make_batch_future(part.id, worker)
  end
  initial_size = futures.size
  until are_futures_ready?(futures, initial_size)
    futures = remove_resolved_futures futures
  end
end