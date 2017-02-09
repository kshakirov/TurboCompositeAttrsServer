class PriceCacher
  def initialize
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @price_reader = PriceAttrReader.new @redis_cache
    @price_comparator = PriceAttributeComparator.new
    @fd = File.new("price_changes.dat", "w")
  end


  def compare_prices new_price, old_price
    comparison = @price_comparator.p_equal?(new_price, old_price)
    unless comparison
      @fd.puts new_price['partId']
      puts new_price['partId']
    end
    comparison
  end

  def _cache_product_prices ids, prices
    ids.each_with_index do |id, index|
      unless compare_prices(prices[index], @price_reader.get_price(id))
        @redis_cache.set_cached_response id, "price", prices[index]
      end
    end
  end

  def put ids
    prices = @price_reader.get_rest_prices ids
    _cache_product_prices ids, prices
  end
end