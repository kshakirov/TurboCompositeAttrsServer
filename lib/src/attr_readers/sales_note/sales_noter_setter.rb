class SalesNoteSetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @sales_note_reader =  SalesNoteAttrReader.new
    @redis_cache = redis_cache
  end

  def add_part_number sns, sku
    if sku
    part = Part.find sku
      sns.map{|sn|
        sn[:part_number] = part.manfr_part_num
        sn
      }
    end
  end

  def cache_sales_note sku
      sns = add_part_number(@sales_note_reader.get_attribute(sku), sku)
      @redis_cache.set_cached_response sku, 'sales_note', sns
  end

  def set_sales_note_attribute sku
    cache_sales_note sku
  end
end