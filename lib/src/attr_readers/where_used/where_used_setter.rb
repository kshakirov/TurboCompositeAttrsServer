class WhereUsedSetter
  def initialize redis_cache, graph_service_url
    @where_used_reader = WhereUsedAttrReader.new graph_service_url
    @where_used_builder = WhereUsedBuilder.new redis_cache
    @redis_cache = redis_cache
    @price_getter = PriceGetter.new(@redis_cache)
  end

  def get_prices wus
    skus = wus.map {|w| w[:sku]}
    @price_getter.bulk_get_price_attribute skus
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

  def dto_where_useds wus, part_type
    @where_used_builder.build wus, part_type
  end

  def cache_where_used sku, wus
    @redis_cache.set_cached_response sku, 'where_used', wus
  end

  def query_where_used_service sku
    wus = @where_used_reader.get_attribute(sku)
    wus ||= []
  end

  def conv_array_to_hash wus
    Hash[wus.map {|wu| [wu[:sku], wu]}]
  end

  def get_part_type sku
    part = Part.eager_load(:part_type).find sku
    part.part_type.name
  end

  def set_where_used_attribute sku
    part_type = get_part_type(sku)
    wus = query_where_used_service sku
    wus = dto_where_useds(wus, part_type)
    prices = get_prices(wus)
    wus = conv_array_to_hash wus
    add_prices_to_response wus, prices
    cache_where_used sku, wus
    wus
  end
end