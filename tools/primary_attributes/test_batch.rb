require_relative '../mappers_helper'
require_relative 'first_stage_worker'
require_relative 'second_stage_worker'

pool_size = ARGV[0].to_i || 4
completion_size = 0
redis_host = get_redis_host
redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
graph_service_url = get_service_configuration
first_worker = FirstStageWorker.pool size: pool_size, args: [redis_cache, graph_service_url]
second_worker = SecondStageWorker.pool size: pool_size, args: [redis_cache, graph_service_url]


def make_batch_future id, worker
  worker.future.set_attribute(id)
end

# puts "Starting First Stage "
# Part.find_in_batches(batch_size: pool_size).each do |group|
#   futures = []
#   ids = group.map do |part|
#     futures.push make_batch_future(part.id, first_worker)
#     part.id
#   end
#   puts "First Stage  Ids   => " + ids.join(",")
#   initial_size = futures.size
#   completion_size += initial_size
#   until are_futures_ready?(futures, initial_size)
#     futures = remove_resolved_futures futures
#   end
# end

puts "Starting Second Stage "
Part.find_in_batches(batch_size: pool_size).each do |group|
  futures = []
  ids = group.map do |part|
    futures.push make_batch_future(part.id, second_worker)
    part.id
  end
  puts "Second Stage Ids => " + ids.join(",")
  initial_size = futures.size
  completion_size += initial_size
  until are_futures_ready?(futures, initial_size)
    futures = remove_resolved_futures futures
  end
end