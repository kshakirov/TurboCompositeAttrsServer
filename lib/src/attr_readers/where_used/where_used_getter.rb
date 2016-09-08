class WhereUsedGetter
  def initialize redis_cache=nil
    @group_prices_map = {'11' => 'E'}
    @redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @decriptor = CustomerInfoDecypher.new
  end

  def add_group_price where_useds, group_id
    unless where_useds.nil?
      where_useds.each do |key, value|
        unless value[:prices].nil?
          where_useds[key][:prices] = value[:prices][group_id.to_sym]
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

  def get_cached_where_used sku
    @redis_cache.get_cached_response sku, 'where_used'
  end

  def get_where_used_attribute sku, id
    group_id = @decriptor.get_customer_group id
    wus = get_cached_where_used sku
    if group_id=='no stats'
      remove_price wus
    else
      add_group_price wus, @group_prices_map[group_id]
    end
  end
end