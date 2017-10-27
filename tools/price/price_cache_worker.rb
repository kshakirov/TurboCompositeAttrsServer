class PriceCacheWorker
  include Celluloid
  def initialize redis_cache
    @redis_cache = redis_cache
    @price_reader = PriceAttrReader.new @redis_cache
    @price_comparator = PriceAttributeComparator.new
  end


  def compare_prices new_price, old_price
     @price_comparator.p_equal?(new_price, old_price)
  end


  def  select_changed_prices ids, prices
    ids.each_with_index.select do  |id, index|
      not compare_prices(prices[index], @price_reader.get_price(id))
    end
  end

  def  cache_product_prices changed_prices, prices
    changed_prices.map do |id, index|
      @redis_cache.set_cached_response id, "price", prices[index]
      id
    end
  end

  def put ids
    prices = @price_reader.get_rest_prices ids
    selected  =select_changed_prices(ids, prices)
    cache_product_prices(selected, prices)
  end
end