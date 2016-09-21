class WhereUsedGetter
  def initialize redis_cache=nil
    @price_manager = WhereUsedPriceManager.new
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @decriptor = CustomerInfoDecypher.new
  end

  def get_cached_where_used sku
    @redis_cache.get_cached_response sku, 'where_used'
  end

  def get_where_used_attribute sku, id
    group_id = @decriptor.get_customer_group id
    wus = get_cached_where_used sku
    if group_id=='no stats'
      @price_manager.remove_price wus
    else
      @price_manager.add_group_price wus, group_id
    end
  end
end