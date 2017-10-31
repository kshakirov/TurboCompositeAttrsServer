class ZeroStageWorker
  include Celluloid
  def initialize redis_cache
    @redis_cache = redis_cache
    @price_reader = PriceAttrReader.new @redis_cache
  end

  def cache_product_prices prices
    prices.each do |price|
      @redis_cache.set_cached_response price['partId'], "price", price
    end
  end

  def set_attribute ids
    prices = @price_reader.get_rest_prices ids
    cache_product_prices(prices)
    "Future Finished sku [#{ids.to_s}]"
  end
end