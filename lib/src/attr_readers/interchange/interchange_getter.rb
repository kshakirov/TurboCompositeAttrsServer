class InterchangeGetter

  def initialize redis_cache
    @redis_cache = redis_cache
  end

  def get_cached_interchange sku
    @redis_cache.get_cached_response sku, 'interchanges'
  end

  def get_interchange_attribute sku
    get_cached_interchange sku

  end
end