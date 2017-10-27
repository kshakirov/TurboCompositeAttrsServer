require_relative '../mappers_helper'
require_relative 'price_mapper_utils'
require_relative 'price_cache_worker'
require_relative 'price_audit_updater'

redis_host = get_redis_host
redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
@price_worker = PriceCacheWorker.pool args: [redis_cache]
@price_audit_updater = PriceAuditUpdater.new redis_cache
timers = Timers::Group.new
start_time = Time.new

ti_ids = batch_get_ti_parts_ids
futures = create_futures(ti_ids)

every_five_seconds = timers.every(10) do
  if are_futures_ready? get_unresolved_futures(futures)
    #resolve_futures(futures)
    timers.cancel
    exit(0)
  end
  current_time = Time.new
  puts "Another #{TimeDifference.between(start_time, current_time).in_seconds} seconds"
end
loop { timers.wait }