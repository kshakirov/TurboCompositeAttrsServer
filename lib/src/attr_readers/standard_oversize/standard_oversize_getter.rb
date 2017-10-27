class StandardOversizeGetter

  def initialize redis_cache
    @redis_cache = redis_cache
  end

  def get_standard_oversize sku
    @redis_cache.get_cached_response sku, 'standard_oversize'
  end

end