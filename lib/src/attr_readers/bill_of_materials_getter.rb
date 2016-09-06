class BomGetter

  def initialize
    @group_prices_map = {'11' => 'E'}
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @decriptor = CustomerInfoDecypher.new
  end

  def add_group_price boms, group_id
    unless boms.nil?
      boms.each_with_index do |value, index|
        unless value[:prices].nil?
          boms[index][:prices] = value[:prices][group_id.to_sym]
        end
      end
    end
  end

  def remove_bom_price boms
    unless boms.nil?
      boms.each_with_index do |value, index|
        boms[index][:prices] = 'login'
      end
    end
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
      remove_bom_price boms
    else
      add_group_price boms, @group_prices_map[group_id]
    end
  end

  def get_bom_attribute sku, id
    if id.nil?
      _get_bom_without_prices sku
    else
      _get_bom_with_prices sku, id
    end
  end

  def filter_major_components_only boms
    mcs = []
    boms.each do |bom|
      if bom[:part_type_parent] == 'major_component'
        mcs.push bom
      end
    end
    mcs
  end

  def get_major_component sku, id
    boms = _get_bom_with_prices sku, id
    filter_major_components_only boms
  end

end