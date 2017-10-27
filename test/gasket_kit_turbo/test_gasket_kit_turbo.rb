require_relative "../test_helper"

class TestGasketTurbo < MiniTest::Unit::TestCase
  def setup
    redis_host = get_redis_host
    redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
    @gasket_turbo_reader = GasketTurboReader.new redis_cache
    @gasket_turbo_setter = GasketTurboSetter.new redis_cache
    @gasket_turbo_getter= GasketTurboGetter.new redis_cache
  end

  def test_gasket_reader
    kits = @gasket_turbo_reader.get_attribute 10667
    refute_nil kits
  end

  def test_gasket_setter
    kits = @gasket_turbo_setter.set_gasket_turbo_attribute 10667
    refute_nil kits
  end

  def test_gasket_getter
    kits = @gasket_turbo_getter.get_gasket_turbo_attribute 10667,'E'
    refute_nil kits
  end

end