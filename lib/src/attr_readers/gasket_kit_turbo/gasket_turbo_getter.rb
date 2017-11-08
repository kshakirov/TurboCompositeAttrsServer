class GasketTurboGetter
  extend Forwardable
  def_delegator :@price_manager, :remove_price, :remove_price
  def_delegator :@price_manager, :add_group_price, :add_group_price

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @redis_cache = redis_cache
    @price_manager = GasketTurboPriceManager.new
  end

  def get_cached_gasket_turbo sku
    @redis_cache.get_cached_response sku, 'gasket_turbo'
  end

  def get_gasket_turbo_with_prices sku, id
    turbos = get_cached_gasket_turbo(sku)
    if id=='not_authorized'
      remove_price(turbos)
    else
      add_group_price(turbos, id)
    end
  end

  def get_gasket_turbo_attribute sku, id
    get_gasket_turbo_with_prices sku, id
  end
end