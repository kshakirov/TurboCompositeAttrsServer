class WhereUsedSetter
  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @where_used_reader = WhereUsedAttrReader.new
    @where_used_builder = WhereUsedBuilder.new
    @redis_cache = redis_cache
    @price_reader = PriceAttrReader.new(@redis_cache)
  end

  def get_prices ids
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

  def add_standard_attrs_2_wu wus
    ids = @where_used_builder.build wus
    add_prices_to_response wus, get_prices(ids)
  end

  def cache_where_used sku
    wus = @where_used_reader.get_attribute(sku)
    unless wus.nil?
      wus = add_standard_attrs_2_wu(wus)
      @redis_cache.set_cached_response sku, 'where_used', wus
    end
  end

  def set_where_used_attribute sku
    cache_where_used sku
  end
end