class ServiceKitGetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @redis_cache =  redis_cache
    @decriptor = CustomerInfoDecypher.new
    @group_prices_map = {'11' => 'E'}
  end

  def add_group_price sks, group_id
    unless sks.nil?
      sks.each_with_index do |value, index|
        unless value[:prices].nil?
          sks[index][:prices] = value[:prices][group_id.to_sym]
        end
      end
    end
  end

  def remove_sk_price sks
    unless sks.nil?
      sks.each_with_index do |value,index|
        sks[index][:prices] = 'login'
      end
    end
  end

  def get_cached_sk sku
    @redis_cache.get_cached_response sku, 'service_kits'
  end

  def get_service_kit_attribute sku, id
    group_id = @decriptor.get_customer_group id
    service_kits = get_cached_sk sku
    if group_id=='no stats'
      remove_sk_price service_kits
    else
      add_group_price service_kits, @group_prices_map[group_id]
    end
  end
end