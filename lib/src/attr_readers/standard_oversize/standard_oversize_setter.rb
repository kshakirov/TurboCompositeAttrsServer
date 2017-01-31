class StandardOversizeSetter
  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @standard_oversize_reader = StandardOversizeAttrReader.new
    @redis_cache = redis_cache
  end

  private

  def cache_standard_oversize sku
    standard_oversize = @standard_oversize_reader.get_attribute(sku)
    @redis_cache.set_cached_response(sku, 'standard_oversize', standard_oversize)
  end

  public
  def set_std_oversize_attribute sku
    cache_standard_oversize sku
  end
end