require_relative "../test_helper"

class TestProductsAttrsReader < MiniTest::Unit::TestCase

  def setup
    @service_configuration = get_service_configuration
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end

  def test_where_used_setter
    setter = WhereUsedSetter.new @redis_cache, @service_configuration
    setter.set_where_used_attribute 42873
    setter.set_where_used_attribute 6242

  end

  def test_where_used_getter
    getter = WhereUsedGetter.new @redis_cache
    attrs = getter.get_where_used_attribute  6242,  'E'
    assert_equal  attrs.keys.size, 4
    attrs = getter.get_where_used_attribute  42873,  'E'
    assert_equal  attrs.keys.size, 47
    assert attrs.values.find{|a| a[:partNumber]=='409172-0009'}
    assert attrs.key? 625.to_s.to_sym
    assert_equal "409172-0106", attrs[464.to_s.to_sym][:partNumber]
    assert_equal %W( 466674-0005 2674A076),attrs[464.to_s.to_sym][:turboPartNumbers]

  end

  def test_reader
    reader = WhereUsedAttrReader.new @service_configuration
    wus = reader.get_attribute  6242
    assert_equal  wus.size, 4
    wus = reader.get_attribute  42768
    assert_equal 318,  wus.size
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