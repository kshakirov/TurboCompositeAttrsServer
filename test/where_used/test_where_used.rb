require_relative "../test_helper"

class TestProductsAttrsReader < MiniTest::Unit::TestCase

  def setup
    @service_configuration = get_service_configuration
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end

  def test_where_used_setter
    setter = WhereUsedSetter.new @redis_cache, @service_configuration
    setter.set_where_used_attribute 49639
    setter.set_where_used_attribute 6242
    setter.set_where_used_attribute 42128
    setter.set_where_used_attribute 25179
    setter.set_where_used_attribute 6700

  end

  def test_where_used_getter
    getter = WhereUsedGetter.new @redis_cache
    attrs = getter.get_where_used_attribute  49639,  'E'
    assert_equal  'Cartridge', attrs['4742'.to_sym][:partType]
    assert_equal  'CHRA, CT10', attrs['6673'.to_sym][:description]
    refute_nil attrs['6673'.to_sym][:prices]
    assert_equal  117.8, attrs['6673'.to_sym][:prices]

  end

  def test_reader
    reader = WhereUsedAttrReader.new @service_configuration
    wus = reader.get_attribute  6242
    assert wus.size > 0
    wus = reader.get_attribute  42768
    assert_equal 319,  wus.size
  end

  def test_manufacturer
    manfr = ManufacturerSingleton.instance
    assert  manfr.get_manufacturer_name 1
    part_type = PartTypeSingleton.instance
    assert part_type.get_part_type_name 2
  end

  def test_turbo_model
    turbo =  Turbo.find 35008
    assert_equal  'RHB6',  turbo.turbo_model.turbo_type.name
  end


 end