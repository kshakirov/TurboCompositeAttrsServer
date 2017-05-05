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
    service_kits = get_cached_sk sku
    if id=='not_authorized' or id.nil?
      @price_manager.remove_sk_price service_kits
    else
      @price_manager.add_group_price service_kits, id
    end
  end
end