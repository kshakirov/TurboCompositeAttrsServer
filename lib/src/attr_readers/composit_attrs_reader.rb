class CompositAttrsReader
  def initialize redis_cache=nil

    @where_used_reader = WhereUsedAttrReader.new
    @decriptor = CustomerInfoDecypher.new
    @bom_reader = BillOfMaterialsAttrReader.new
    @interchange_reader = InterchangeAttrReader.new
    @group_prices_map = {'11' => 'E'}
    @sales_note_reader =  SalesNoteAttrReader.new
    @kit_matrix = ServiceKitsAttrReader.new
    @service_kits = ServiceKitsAttrReader.new
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @price_reader = PriceAttrReader.new(@redis_cache)


  end

  def get_prices ids
    @price_reader.get_attribute ids
  end

  def add_prices_to_response response, prices
    response.each do |key, value|
      prices.each do |price|
        if price[:partId] == key
          response[key][:prices] = price[:prices]
        end
      end
    end
  end

  def add_standard_attrs_2_wu where_useds
    if not where_useds.nil?
      ids = []
      where_useds.each do |key, value|
        part = Part.find value[:sku]
        ids.push value[:sku]
        where_useds[key][:description] = part.description
      end
      add_prices_to_response(where_useds, get_prices(ids))
    else
      nil
    end

  end

  def get_all_composite_attrs sku
    response = {}
    response[:where_used]= add_standard_attrs_2_wu(@where_used_reader.get_attribute(sku))
    response
  end

  def adjuct_group_price where_useds, group_id
    unless where_useds.nil?
      where_useds.each do |key, value|
        unless value[:prices].nil?
          where_useds[key][:prices] = value[:prices][group_id]
        end
      end
    end
  end

  def remove_price where_useds
    unless where_useds.nil?
      where_useds.each do |key, value|
        where_useds[key][:prices] = 'login'
      end
    end
  end

  def get_cached_wu sku
    response = @redis_cache.get_cached_response sku, 'where_used'

    if response
       response
    else
      wus = add_standard_attrs_2_wu(@where_used_reader.get_attribute(sku))
      @redis_cache.set_cached_response sku, 'where_used', wus
      wus
    end
  end

  def get_where_used_attribute sku, id
    group_id = @decriptor.get_customer_group id
    wus = get_cached_wu sku
    if group_id=='no stats'
      remove_price wus
    else
      adjuct_group_price wus, @group_prices_map[group_id]
    end
  end
end