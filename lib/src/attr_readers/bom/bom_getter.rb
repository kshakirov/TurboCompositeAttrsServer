class BomGetter

  def initialize redis_cache= RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @redis_cache = redis_cache
    @decriptor = CustomerInfoDecypher.new
    @major_component_builder = MajorComponent.new
    @price_manager = BomPriceManager.new
  end

  def get_cached_bom sku
    @redis_cache.get_cached_response sku, 'bom'
  end

  def _get_bom_without_prices sku
    get_cached_bom sku
  end

  def _get_bom_with_prices sku, id
    group_id = @decriptor.get_customer_group id
    boms = get_cached_bom sku
    if group_id=='no stats'
      @price_manager.remove_bom_price boms
    else
      @price_manager.add_group_price boms, group_id
    end
  end

  def get_bom_attribute sku, id
    if id.nil?
      _get_bom_without_prices sku
    else
      _get_bom_with_prices sku, id
    end
  end

  def get_major_component sku, id
    boms = _get_bom_with_prices sku, id
    @major_component_builder.build boms
  end

end