class WhereUsedSetter
  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3)), graph_service_url
    @where_used_reader = WhereUsedAttrReader.new graph_service_url
    @where_used_builder = WhereUsedBuilder.new
    @redis_cache = redis_cache
    @price_reader = PriceAttrReader.new(@redis_cache)
  end

  def get_prices wus
    ids = wus.map{|w| w[:sku]}
    @price_reader.get_attribute ids
  end

  def add_prices_to_response response, prices
    response.each do |key, value|
      prices.each do |price|
        if price and (price[:partId] == key or price[:partId] == value[:tiSku])
          response[key][:prices] = price[:prices]
        end
      end
    end
  end

  def dto_where_useds wus
    @where_used_builder.build wus
  end

  def cache_where_used sku, wus
    @redis_cache.set_cached_response sku, 'where_used', wus
  end

  def query_where_used_service sku
     @where_used_reader.get_attribute(sku)
  end

  def conv_array_to_hash wus
      Hash[wus.map{|wu| [wu[:sku],wu]}]
  end

  def set_where_used_attribute sku
    wus = query_where_used_service sku
    unless wus.nil?
      wus = dto_where_useds(wus)
      prices =  get_prices(wus)
      wus = conv_array_to_hash wus
      add_prices_to_response wus, prices
      cache_where_used sku, wus
      wus
    end
  end
end