class BomSetter
  include TurboCompositeAttrs
  extend Forwardable


  def_delegator :@bom_builder, :build_bom_dto, :build_bom_dto
  def_delegator :@bom_reader, :get_attribute, :query_bom_service
  def_delegator :@price_reader, :get_attribute, :get_prices
  def_delegator :@redis_cache, :set_cached_response, :cache_bom

  def initialize redis_cache="redis",  graph_service_url
    @bom_reader = BomReader.new graph_service_url
    @redis_cache = RedisCache.new(Redis.new(:host => redis_cache, :db => 3))
    @price_reader = PriceAttrReader.new(@redis_cache)
    @bom_builder = BomBuilder.new
  end

  def set_bom_attribute sku
    boms = query_bom_service(sku)
    boms_dto = build_bom_dto(boms)
    boms_dto = add_prices_to_boms_list(boms_dto, get_prices(get_boms_ids(boms_dto)))
    cache_bom(sku, 'bom',  boms_dto)
  end

end