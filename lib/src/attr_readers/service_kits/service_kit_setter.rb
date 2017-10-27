class ServiceKitSetter

  def initialize redis_host
    @service_kits = ServiceKitsAttrReader.new
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
    @price_reader = PriceAttrReader.new(@redis_cache)
    @builder = ServiceKitBuilder.new
  end

  def get_prices ids
    @price_reader.get_attribute ids
  end

  def add_prices_to_sk_response sks, prices
    sks.each_with_index do |sk, index|
      prices.each do |price|
        if price and price[:partId] == sk[:tiSku]
          sks[index][:prices] = price[:prices]
        end
      end
    end
  end

def add_standard_attrs_2_sk service_kits
      ids = @builder.build service_kits
      add_prices_to_sk_response(service_kits, get_prices(ids))
  end

  def cache_service_kit sku, service_kits
    @redis_cache.set_cached_response sku, 'service_kits', service_kits
  end

  def set_service_kit_attribute sku
    service_kits = @service_kits.get_attribute sku || []
    add_standard_attrs_2_sk service_kits
    cache_service_kit sku, service_kits
  end
end