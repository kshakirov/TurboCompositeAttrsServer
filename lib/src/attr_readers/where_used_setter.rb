class WhereUsedSetter
  def initialize redis_cache=nil
    @where_used_reader = WhereUsedAttrReader.new
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @price_reader = PriceAttrReader.new(@redis_cache)
  end

  def get_prices ids
    @price_reader.get_attribute ids
  end

  def add_prices_to_response response, prices
    response.each do |key, value|
      prices.each do |price|
        if price[:partId] == key
          response[key][:prices] = price[:prices]
        end
      end
    end
  end

  def add_standard_attrs_2_wu where_useds
    if not where_useds.nil?
      ids = []
      where_useds.each do |key, value|
        part = Part.find value[:sku]
        ids.push value[:sku]
        where_useds[key][:description] = part.description
      end
      add_prices_to_response(where_useds, get_prices(ids))
    else
      nil
    end

  end

  def get_all_composite_attrs sku
    response = {}
    response[:where_used]= add_standard_attrs_2_wu(@where_used_reader.get_attribute(sku))
    response
  end

  def cache_where_used sku
    wus = add_standard_attrs_2_wu(@where_used_reader.get_attribute(sku))
    @redis_cache.set_cached_response sku, 'where_used', wus
  end

  def set_where_used_attribute sku
    cache_where_used sku
  end
end