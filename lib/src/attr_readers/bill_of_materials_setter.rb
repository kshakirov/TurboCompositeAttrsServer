class BomSetter

  def initialize redis_cache=nil
    @bom_reader = BomReader.new
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @price_reader = PriceAttrReader.new(@redis_cache)
  end

  def get_prices ids
    @price_reader.get_attribute ids
  end

  def add_ti_part_number ti_sku
    ti_part_numbers = []
    if ti_sku.size > 0
      ti_sku.each do |sku|
        if sku
          part = Part.find sku
          ti_part_numbers.push(part.manfr_part_num)
        end
      end
    end
    ti_part_numbers
  end


  def add_prices_to_bom_response boms, prices
    boms.each_with_index do |bom, index|
      prices.each do |price|
        if price[:partId] == bom[:sku]
          boms[index][:prices] = price[:prices]
        end
      end
    end
  end


  def add_standard_attrs_2_bom boms
    if not boms.nil?
      ids = []
      boms.each_with_index do |bom, index|
        part = Part.find bom[:sku]
        ids.push bom[:sku]
        boms[index][:description] = part.description
        boms[index][:part_type] = part.part_type.name
        boms[index][:part_number] = part.manfr_part_num
        boms[index][:ti_part_number] = add_ti_part_number(boms[index][:ti_part_sku])
        boms[index][:name] = part.name || boms[index][:part_type] + '-' + boms[index][:part_number]
      end
      add_prices_to_bom_response(boms, get_prices(ids))
      boms
    else
      nil
    end
  end


  def cache_bom sku
    boms = add_standard_attrs_2_bom(@bom_reader.get_attribute sku)
    @redis_cache.set_cached_response sku, 'bom', boms
  end

  def set_bom_attribute sku
    cache_bom sku
  end

end