class GasketKitSetter
  def initialize redis_cache
    @gasket_turbo_reader = GasketKitReader.new redis_cache
    @redis_cache = redis_cache
    @price_getter = PriceGetter.new(@redis_cache)
  end

  private
  def add_prices gasket_kit_turbos
    gasket_kit_turbos.map { |t|
      t[:prices] = @price_getter.get_price_attribute(t[:id])
      t
    }
  end

  def cache_gasket_kit sku, gasket_kit_turbos
    @redis_cache.set_cached_response(sku, 'gasket_kit', gasket_kit_turbos)
  end

  public
  def set_gasket_kit_attribute sku
    gasket_kit_turbos = @gasket_turbo_reader.get_attribute(sku)
    gasket_kit_turbos = add_prices(gasket_kit_turbos)
    cache_gasket_kit sku, gasket_kit_turbos
  end
end
