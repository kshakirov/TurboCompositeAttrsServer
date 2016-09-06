class SalesNoteGetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @redis_cache = redis_cache
  end

  def get_cached_note sku
    @redis_cache.get_cached_response sku, 'sales_note'
  end

  def get_sales_note_attribute sku
    get_cached_note sku
  end
end