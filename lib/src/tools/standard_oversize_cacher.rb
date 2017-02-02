class StandardOversizeCacher
  def initialize
    redis_client = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @std_oversize_setter = StandardOversizeSetter.new redis_client
  end

  def put sku
    @std_oversize_setter.set_std_oversize_attribute  sku
  end
end