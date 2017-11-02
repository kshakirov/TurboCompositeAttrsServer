class KitMatrixGetter

  def initialize redis_cache
    @redis_cache = redis_cache
  end

  def get_cached_km sku
    @redis_cache.get_cached_response sku, 'kit_matrix'
  end

  def get_kit_matrix_attribute sku
    get_cached_km sku
  end
end