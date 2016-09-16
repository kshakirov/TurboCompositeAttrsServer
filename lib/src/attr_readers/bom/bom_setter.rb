class BomSetter

  def initialize redis_cache=nil
    @bom_reader = BomReader.new
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @price_reader = PriceAttrReader.new(@redis_cache)
    @bom_builder = BomBuilder.new
  end

  def get_prices ids
    @price_reader.get_attribute ids
  end

  def add_prices_to_bom boms, prices
    boms_array = []
    boms.each_value do |bom|
      prices.each do |price|
        if price and  price[:partId] == bom[:sku]
          bom[:prices] = price[:prices]
          boms_array.push bom
        end
      end
    end
    boms_array
  end

  def get_boms_ids bom_hash
    ids = []
    bom_hash.each_key  { |b| ids.push b.to_s }
    ids
  end

  def build_bom boms
    bom_hash = @bom_builder.build(boms)
    add_prices_to_bom bom_hash, get_prices(get_boms_ids(bom_hash))
  end

  def cache_bom sku
    boms = build_bom(@bom_reader.get_attribute sku)
    @redis_cache.set_cached_response sku, 'bom', boms
  end

  def set_bom_attribute sku
    cache_bom sku
  end

end