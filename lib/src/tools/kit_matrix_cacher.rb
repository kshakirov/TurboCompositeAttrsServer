class KitMatrixCacher
  def initialize
    redis_client = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @kit_matrix_setter = KitMatrixSetter.new redis_client
  end

  def put sku
    @kit_matrix_setter.set_kit_matrix_attribute  sku
  end
end