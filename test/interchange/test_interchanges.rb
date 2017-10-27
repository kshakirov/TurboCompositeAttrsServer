require_relative "../test_helper"

class TestInterchangeAttrsReader < MiniTest::Unit::TestCase

  def setup
    @service_configuration = get_service_configuration
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end

  def test_interchange_setter
    setter = InterchangeSetter.new @redis_cache, @service_configuration
    setter.set_interchange_attribute 6392
    setter.set_interchange_attribute 6243
    setter.set_interchange_attribute 7130
    setter.set_interchange_attribute 6991
    setter.set_interchange_attribute 3756
    setter.set_interchange_attribute 48536
    setter.set_interchange_attribute 840
    setter.set_interchange_attribute 6392
  end

  def test_interchange_getter
    getter = InterchangeGetter.new @redis_cache
    attrs = getter.get_interchange_attribute 6392
    assert_equal 4, attrs.size
    assert_equal 1983, attrs[1][:id]
  end

  def test_reader
    reader = InterchangeReader.new @service_configuration
    interchanges = reader.get_attribute(70793)
    assert  interchanges
  end


end