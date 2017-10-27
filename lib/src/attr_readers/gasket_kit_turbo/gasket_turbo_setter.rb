class GasketTurboSetter

  def initialize redis_cache
    @gasket_turbo_reader = GasketTurboReader.new redis_cache
    @redis_cache = redis_cache
    @price_reader = PriceAttrReader.new(@redis_cache)
  end

  private

  def add_prices gasket_turbo
    unless gasket_turbo[:ti_id].nil?
      gasket_turbo[:prices] = @redis_cache.get_cached_response(gasket_turbo[:ti_id], "price")
    end
    gasket_turbo
  end

  def cache_gasket_turbo sku
    gasket_turbo = @gasket_turbo_reader.get_attribute(sku)
    if gasket_turbo
      add_prices(gasket_turbo)
      @redis_cache.set_cached_response(sku, 'gasket_turbo', gasket_turbo)
    end
  end

  public
  def set_gasket_turbo_attribute sku
    cache_gasket_turbo sku
  end
end
