class BomSetter
  include TurboCompositeAttrs
  extend Forwardable

  def initialize redis_cache, graph_service_url
    @bom_reader = BomReader.new graph_service_url
    @redis_cache =  redis_cache
    @price_reader = PriceAttrReader.new(@redis_cache)
    @bom_builder = BomBuilder.new redis_cache
  end

  def get_prices bom_ids
    @price_reader.get_attribute(bom_ids)
  end

  def build_bom_dto boms
    @bom_builder.build_bom_dto boms
  end

  def query_bom_service sku
    @bom_reader.get_attribute sku
  end

  def get_boms_ids bom_list
    bom_list.compact!
    bom_list.map { |b| b[:sku] }
  end

  def add_prices_to_boms_list boms, prices
    boms.map do |bom|
      get_bom_item_prices(bom, prices)
      bom
    end
  end

  def get_bom_item_prices bom, prices
    price = prices.select{|p| p and p[:partId] == bom[:sku]}
    unless price.empty?
      bom[:prices] = price.first[:prices]
    end
  end

  def cache_bom sku, code, boms_dto
    @redis_cache.set_cached_response sku, code, boms_dto
  end

  def set_bom_attribute sku
    boms = query_bom_service(sku) || []
    boms_dto = build_bom_dto(boms)
    boms_ids = get_boms_ids(boms_dto)
    boms_prices = get_prices(boms_ids)
    boms_dto = add_prices_to_boms_list(boms_dto, boms_prices)
    cache_bom(sku, 'bom', boms_dto)
  end

end