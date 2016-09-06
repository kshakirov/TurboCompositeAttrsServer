class ServiceKitSetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @service_kits = ServiceKitsAttrReader.new
    @redis_cache =  redis_cache
    @price_reader = PriceAttrReader.new(@redis_cache)
  end

  def get_prices ids
    @price_reader.get_attribute ids
  end

  def add_prices_to_sk_response sks, prices
    sks.each_with_index do |sk, index|
      prices.each do |price|
        if price[:partId] == sk[:sku]
          sks[index][:prices] = price[:prices]
        end
      end
    end
  end

  def _get_ti_part_number sku
    unless sku.nil?
      part = Part.find sku
      part.manfr_part_num
    end
  end

  def add_standard_attrs_2_sk service_kits
    if not service_kits.nil?
      ids = []
      service_kits.each_with_index do |value, index|
        part = Part.find value[:sku]
        ids.push value[:sku]
        service_kits[index][:part_number] = part.manfr_part_num
        service_kits[index][:ti_part_number] = _get_ti_part_number(value[:tiSku])
        service_kits[index][:description] = part.description
      end
      add_prices_to_sk_response(service_kits, get_prices(ids))
    else
      nil
    end
  end

  def cache_service_kit sku
    service_kits = @service_kits.get_attribute sku
    add_standard_attrs_2_sk service_kits
    @redis_cache.set_cached_response sku, 'service_kits', service_kits
  end

  def set_service_kit_attribute sku
    cache_service_kit sku
  end
end