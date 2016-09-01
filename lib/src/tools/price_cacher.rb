class PriceCacher
  def initialize
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @price_reader = PriceAttrReader.new @redis_cache
  end

  def _cache_product_prices ids, prices
      ids.each_with_index  do |id, index|
          @redis_cache.set_cached_response id, "price", prices[index]
      end
  end
   def put ids
      prices = @price_reader.get_rest_prices ids
     _cache_product_prices ids, prices
   end
end