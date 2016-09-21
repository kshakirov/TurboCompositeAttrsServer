class ServiceKitGetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @redis_cache =  redis_cache
    @decriptor = CustomerInfoDecypher.new
    @price_manager = ServiceKitPriceManager.new
  end

  def get_cached_sk sku
    @redis_cache.get_cached_response sku, 'service_kits'
  end

  def get_service_kit_attribute sku, id
    group_id = @decriptor.get_customer_group id
    service_kits = get_cached_sk sku
    if group_id=='no stats'
      @price_manager.remove_sk_price service_kits
    else
      @price_manager.add_group_price service_kits, group_id
    end
  end
end