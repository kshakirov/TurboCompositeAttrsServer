class GasketKitGetter
  extend Forwardable

  def initialize redis_cache
    @redis_cache = redis_cache
    @price_manager = GasketKitPriceManager.new
  end

  def get_cached_gasket_kit sku
    @redis_cache.get_cached_response sku, 'gasket_kit'
  end

  def get_gasket_kit_with_prices sku, id
    turbos = get_cached_gasket_kit(sku)
    if id=='not_authorized'
      @price_manager.remove_price(turbos)
    else
      @price_manager.add_group_price(turbos, id)
    end
  end

  def get_gasket_kit_attribute sku, id
    get_gasket_kit_with_prices sku, id
  end
end