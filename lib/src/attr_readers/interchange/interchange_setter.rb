class InterchangeSetter
  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3)), graph_service_url
    @interchange_reader = InterchangeReader.new graph_service_url
    @redis_cache = redis_cache
  end

  def _dto_interchanges raw_interchanges
    ids = raw_interchanges.compact
    ids.map do |id|
      part = Part.find id
      {
          id: id,
          manufacturer: part.manfr.name,
          description: part.description,
          part_number: part.manfr_part_num,
          inactive: part.inactive
      }
    end
  end


  def cache_interchange sku, interchanges_dto
    @redis_cache.set_cached_response sku, 'interchanges', interchanges_dto
  end

  def get_raw_interchanges sku
    @interchange_reader.get_attribute sku
  end

  def filter_out_inactive interchanges
      interchanges.select do |i|
        not i[:inactive]
      end
  end

  def dto_interchanges raw_interchanges
    interchanges = _dto_interchanges raw_interchanges
    filter_out_inactive interchanges
  end

  def set_interchange_attribute sku
    raw_interchanges = get_raw_interchanges sku
    interchanges_dto = dto_interchanges raw_interchanges
    cache_interchange sku, interchanges_dto
  end
end