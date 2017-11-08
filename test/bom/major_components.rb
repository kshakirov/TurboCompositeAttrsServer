require_relative "../test_helper"

class TestMajorComponentsReader < MiniTest::Unit::TestCase

  def setup
    @service_configuration = get_service_configuration
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end
  def test_major_components_gettter
    getter = BomGetter.new @redis_cache
    attrs = getter.get_major_component  6991,  'E'
    assert_equal 6, attrs.size
  end

end