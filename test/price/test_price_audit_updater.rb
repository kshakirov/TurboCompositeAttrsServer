require_relative "../test_helper"
require 'celluloid/current'
require 'celluloid/pool'
require_relative "../../tools/price/price_audit_updater"
require_relative "../../tools/price/price_cache_worker"


@price_cache_worker = PriceCacheWorker.pool
res = @price_cache_worker.put [ 63570,    63632]
p res
