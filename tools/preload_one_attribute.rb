require_relative 'tools_helper'

class SingleAttributeCacher
  def initialize
    redis_client = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @single_attribute_setter = ServiceKitSetter.new redis_client
  end

  def put sku
    @single_attribute_setter.set_service_kit_attribute  sku
  end
end


@products_collection = ProductsCollection.new
@products_collection.cache_one_attribute 0,  SingleAttributeCacher.new