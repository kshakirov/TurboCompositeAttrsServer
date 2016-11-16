class BomSetter
  include TurboCompositeAttrs
  extend Forwardable

  def_delegator :@bom_builder, :build_boms_list, :build_boms_list
  def_delegator :@bom_reader, :get_attribute, :get_part_boms
  def_delegator :@price_reader, :get_attribute, :get_prices
  def_delegator :@redis_cache, :set_cached_response, :cache_bom

  def initialize redis_cache=nil
    @bom_reader = BomReader.new
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @price_reader = PriceAttrReader.new(@redis_cache)
    @bom_builder = BomBuilder.new
  end

  def set_bom_attribute sku
    boms = get_part_boms(sku)
    boms_list = build_boms_list(boms)
    boms_list = add_prices_to_boms_list(boms_list, get_prices(get_boms_ids(boms_list)))
    cache_bom(sku, 'bom',  boms_list)
  end

end