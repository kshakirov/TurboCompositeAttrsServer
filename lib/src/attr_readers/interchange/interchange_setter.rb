class InterchangeSetter
  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3)), graph_service_url
    @interchange_reader = InterchangeReader.new graph_service_url
    @redis_cache = redis_cache
  end

  def _add_standard_attrs_2_interchs (interchanges)
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

  def _dto_interchanges raw_interchanges
    ids = raw_interchanges.compact
    ids.map do |id|
      part = Part.find id
      {
          id: id,
          manufacturer: part.manfr.name,
          description: part.description,
          part_number: part.manfr_part_num
      }
    end
  end


  def cache_interchange sku, interchanges_dto
    @redis_cache.set_cached_response sku, 'interchanges', interchanges_dto
  end

  def get_raw_interchanges sku
    @interchange_reader.get_attribute sku
  end

  def dto_interchanges raw_interchanges
    _dto_interchanges raw_interchanges
  end

  def set_interchange_attribute sku
    raw_interchanges = get_raw_interchanges sku
    interchanges_dto = dto_interchanges raw_interchanges
    cache_interchange sku, interchanges_dto
  end
end