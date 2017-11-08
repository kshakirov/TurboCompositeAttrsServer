class BomGetter
  extend Forwardable

  def initialize redis_cache
    @redis_cache = redis_cache
    @major_component_builder = MajorComponent.new
    @price_manager = BomPriceManager.new
  end

  def get_cached_bom sku, code
    @redis_cache.get_cached_response sku, code
  end

  def _get_bom_without_prices sku
    get_cached_bom sku, 'bom'
  end

  def _get_bom_with_prices sku, id
    boms = get_cached_bom(sku, 'bom')
    if id=='not_authorized' or id.nil?
      @price_manager.remove_bom_price(boms)
    else
      @price_manager.add_group_price(boms, id)
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