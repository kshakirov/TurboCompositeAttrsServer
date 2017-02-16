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
    wus = get_cached_where_used sku
    if id=='not_authorized'
      @price_manager.remove_price wus
    else
      @price_manager.add_group_price wus, id
    end
  end
end