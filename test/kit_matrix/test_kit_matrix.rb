require_relative "../test_helper"

class TestKitMatrix < MiniTest::Unit::TestCase
  def setup
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end

  def test_kit_matrix_setter
    setter = KitMatrixSetter.new @redis_cache
    setter.set_kit_matrix_attribute 6392
  end

  def test_kit_matrix_getter
    getter = KitMatrixGetter.new
    attrs = getter.get_kit_matrix_attribute 6392
    assert_equal 15, attrs[1].size
    assert_equal 44, attrs[0].size
    assert_equal "7-A-3330", attrs[1][14][:field]
    assert_equal 2, attrs[0]['8-A-0204'.to_sym]['7-A-3330'.to_sym]
  end
  def test_dd
    Part.joins(:part_type).where( part_type: {name: ["Cartridge","Turbo"]}).each do |p|
       p.part_type.name
    end
  end
end