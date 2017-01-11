class GasketKitCacher
  def initialize
    redis_client = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @gasket_kit_setter = GasketKitSetter.new redis_client
  end

  def put sku
    @gasket_kit_setter.set_gasket_kit_attribute  sku
  end
end