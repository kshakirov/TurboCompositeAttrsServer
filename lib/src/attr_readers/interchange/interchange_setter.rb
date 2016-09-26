class InterchangeSetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @interchange_reader = InterchangeReader.new
    @redis_cache = redis_cache
  end

  def add_standard_attrs_2_interchs (interchanges)
    if not interchanges.nil?
      ids = []
      interchanges.each_with_index do |interchange, index|
        part = Part.find interchange[:id]
        ids.push interchange[:id]
        interchanges[index][:description] = part.description
        interchanges[index][:part_number] = part.manfr_part_num
      end
      interchanges
    else
      nil
    end
  end

  def cache_interchange sku
    interchanges = @interchange_reader.get_attribute sku
    add_standard_attrs_2_interchs interchanges
    @redis_cache.set_cached_response sku, 'interchanges', interchanges
  end

  def set_interchange_attribute sku
    cache_interchange sku

  end
end