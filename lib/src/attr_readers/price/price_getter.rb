class PriceGetter
  def initialize redis_cache
    @redis_cache = redis_cache
  end

  def get_cached_price sku
    @redis_cache.get_cached_response sku, 'kit_matrix'
  end

  def bulk_get_price_attribute skus
    skus.map do |sku|
      @redis_cache.get_cached_response(sku, "price")
    end
  end

  def get_price_attribute sku
    get_cached_price sku
  end
end