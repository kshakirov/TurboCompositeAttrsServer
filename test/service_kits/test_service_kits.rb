require_relative "../test_helper"

class TestServiceKitsAttrsReader < MiniTest::Unit::TestCase
  def setup
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end

  def test_service_kit_setter
    setter = ServiceKitSetter.new @redis_cache
    setter.set_service_kit_attribute 13958
    setter.set_service_kit_attribute 11036
  end

  def test_service_kit_gettter
    getter = ServiceKitGetter.new  @redis_cache
    attrs = getter.get_service_kit_attribute  13958,  'E'
    assert_equal 49, attrs.size
    assert_equal 42.68,   attrs.last[:prices]
  end

  def test_reader
    reader = ServiceKitsAttrReader.new
    attribute = reader.get_attribute(13958)
    refute_nil attribute
  end

end