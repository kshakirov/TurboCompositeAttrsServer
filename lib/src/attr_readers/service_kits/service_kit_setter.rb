class ServiceKitSetter

  def initialize redis_cache
    @service_kits = ServiceKitsAttrReader.new
    @redis_cache = redis_cache
    @price_getter = PriceGetter.new(@redis_cache)
    @builder = ServiceKitBuilder.new @redis_cache
  end

  def get_prices skus
    @price_getter.bulk_get_price_attribute skus
  end

  def get_skus service_kits_list
    service_kits_list.map do |sk|
      if sk[:tiSku]
        sk[:tiSku]
      else
        sk[:sku]
      end
    end
  end

  def add_prices_to_sk_response service_kits_list, prices
    service_kits_list.map do |sk|
      prices.each do |price|
        if price and price[:partId] == sk[:tiSku]
          sk[:prices] = price[:prices]
        end
      end
      sk
    end
  end

def add_standard_attrs_2_sk service_kits
      service_kits_list =  @builder.build service_kits
      ids = get_skus(service_kits_list)
      add_prices_to_sk_response(service_kits_list, get_prices(ids))
  end

  def cache_service_kit sku, service_kits
    @redis_cache.set_cached_response sku, 'service_kits', service_kits
  end

  def set_service_kit_attribute sku
    service_kits = @service_kits.get_attribute sku || []
    service_kits = add_standard_attrs_2_sk  service_kits
    cache_service_kit sku, service_kits
  end
end