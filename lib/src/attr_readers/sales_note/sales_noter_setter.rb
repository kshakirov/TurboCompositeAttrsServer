class SalesNoteSetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @sales_note_reader =  SalesNoteAttrReader.new
    @redis_cache = redis_cache
  end

  def cache_sales_note sku
      sns = @sales_note_reader.get_attribute sku
      @redis_cache.set_cached_response sku, 'sales_note', sns
  end

  def set_sales_note_attribute sku
    cache_sales_note sku
  end
end