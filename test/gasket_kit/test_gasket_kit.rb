require_relative "../test_helper"

class TestGasketKit < MiniTest::Unit::TestCase
  def setup
    redis_host = get_redis_host
    redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
    @gasket_kit_reader = GasketKitReader.new redis_cache
    @gasket_kit_setter = GasketKitSetter.new redis_cache
    @gasket_kit_getter = GasketKitGetter.new redis_cache
  end

  def test_gasket_reader
    turbos = @gasket_kit_reader.get_attribute 69079
    refute_nil turbos
    assert_equal 5, turbos.size
    assert (turbos.find {|t| t[:id] == 10072})
    assert (turbos.find {|t| t[:id] == 36359})
  end

  def test_gasket_kit_setter
    cached = @gasket_kit_setter.set_gasket_kit_attribute 69079
    refute_nil cached
  end

  def test_gasket_kit_getter
    turbos = @gasket_kit_getter.get_gasket_kit_attribute 69079, 'E'

    assert_equal 5, turbos.size
    assert (turbos.find {|t| t[:id] == 10072})
    assert (turbos.find {|t| t[:id] == 36359})
  end

  def test_reader
    kits = @gasket_kit_reader.get_attribute(7189)
    refute_nil kits
  end


end