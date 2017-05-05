class BomGetter
  extend Forwardable
  def_delegator :@redis_cache, :get_cached_response, :get_cached_bom
  def_delegator :@price_manager, :remove_bom_price, :remove_bom_price
  def_delegator :@price_manager, :add_group_price, :add_group_price
  def_delegator :@decriptor, :get_customer_group, :get_customer_group

  def initialize redis_cache= RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @redis_cache = redis_cache
    @decriptor = CustomerInfoDecypher.new
    @major_component_builder = MajorComponent.new
    @price_manager = BomPriceManager.new
  end

  def _get_bom_without_prices sku
    get_cached_bom sku, 'bom'
  end

  def _get_bom_with_prices sku, id
    boms = get_cached_bom(sku, 'bom')
    if id=='not_authorized' or id.nil?
      remove_bom_price(boms)
    else
      add_group_price(boms, id)
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
    @major_component_builder.build_major_comps_list boms
  end

end