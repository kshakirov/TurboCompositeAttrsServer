class GasketKitSetter
  def initialize redis_cache
    @gasket_turbo_reader = GasketKitReader.new redis_cache
    @redis_cache = redis_cache
    @price_reader = PriceAttrReader.new(@redis_cache)
  end

  private
  def add_prices gasket_kit_turbos
    gasket_kit_turbos.map { |t|
      t[:prices] = @redis_cache.get_cached_response(t[:id], "price")
      t
    }
  end

  def cache_gasket_kit sku
    gasket_kit_turbos = @gasket_turbo_reader.get_attribute(sku)
    add_prices(gasket_kit_turbos)
    @redis_cache.set_cached_response(sku, 'gasket_kit', gasket_kit_turbos)
  end

  public
  def set_gasket_kit_attribute sku
    cache_gasket_kit sku
  end
end
