require_relative "../test_helper"

class TestApplicationReader < MiniTest::Unit::TestCase

  def setup
    @service_configuration = get_service_configuration
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end

  def test_reader
    reader = ApplicationReader.new @redis_cache
    attrs = reader.get_attribute 6524
    assert_equal 41, attrs.size
    attrs = reader.get_attribute 43745
    assert_equal 54, attrs.size
  end

  def test_setter
    setter = ApplicationSetter.new @redis_cache
    setter.set_application_attribute 6524
    setter.set_application_attribute 43745
    setter.set_application_attribute 6392
  end

  def test_setter_sorted
    setter = ApplicationSetter.new @redis_cache
    # setter.set_application_attribute 4
    # setter.set_application_attribute 6583
    setter.set_application_attribute 995
  end


end