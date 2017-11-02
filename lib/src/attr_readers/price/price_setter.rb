class PriceSetter
  def initialize redis_cache
    @redis_cache = redis_cache
    @price_attribute_reader = PriceAttrReader.new
  end

  def bulk_cache_price prices
    prices.each do |price|
      @redis_cache.set_cached_response price['partId'], "price", price
    end
  end

  def set_price_attribute sku, price
    @redis_cache.set_cached_response sku, "price", price
  end

  def bulk_set_price_attribute skus
    prices = @price_attribute_reader.get_rest_prices skus
    bulk_cache_price prices
  end
end