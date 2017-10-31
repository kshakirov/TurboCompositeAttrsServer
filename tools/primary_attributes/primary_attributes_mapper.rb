require_relative '../mappers_helper'
require_relative 'second_stage_worker'


redis_host = get_redis_host
redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
graph_service_url = get_service_configuration
timers = Timers::Group.new

worker = PrimaryAttributeWorker.pool args: [redis_cache, graph_service_url]
futures = map_specific_parts(worker)
ActiveRecord::Base.clear_active_connections!
initial_size = futures.size
start_time = Time.new

every_ten_seconds = timers.every(10) do
  futures = remove_resolved_futures futures
  if are_futures_ready?(futures, initial_size)
    timers.cancel
    exit(0)
  end
  current_time = Time.new
  puts "Another #{TimeDifference.between(start_time, current_time).in_seconds} seconds"
end
loop { timers.wait }
