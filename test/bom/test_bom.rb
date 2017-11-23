require_relative "../test_helper"

class TestBomAttrsReader < MiniTest::Unit::TestCase

  def setup
    @service_configuration = get_service_configuration
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end

  def test_bom_set
    setter = BomSetter.new @redis_cache, @service_configuration
    setter.set_bom_attribute 6392
    setter.set_bom_attribute 6243
    setter.set_bom_attribute 7130
    setter.set_bom_attribute 6991
    setter.set_bom_attribute 3756
    setter.set_bom_attribute 48536
    setter.set_bom_attribute 840
    setter.set_bom_attribute 61643
    setter.set_bom_attribute 68157
    setter.set_bom_attribute 6583
    setter.set_bom_attribute 63702
  end

  def test_bom_get
    getter = BomGetter.new @redis_cache
    attrs = getter.get_bom_attribute 6392, 'E'
    refute_nil attrs
    assert_equal 16, attrs.size
    assert  attrs.find{|a| a[:prices]==53.76}
    part = get_part_by_sku attrs, 47753
    assert_equal 4, part[:quantity]
    attrs = getter.get_bom_attribute 840, 'E'
    refute_nil attrs
    assert_equal 5, attrs.size
    attrs = getter.get_bom_attribute 3756, 'E'
    assert_equal 4, attrs.size
    assert  attrs.find{|a| a[:prices]==3.712}
    assert  attrs.find{|a| a[:oe_part_number]=='49179-30220'}
    attrs = getter.get_bom_attribute 48536, 'E'
    assert_equal 17, attrs.size
    assert  attrs.find{|a| a[:part_number]=='8-A-1560'}
    attrs = getter.get_bom_attribute 6583, 'E'
    dups = attrs.select {|b| b[:sku]==48145}
    assert_equal 2, dups.size
    attrs = getter.get_bom_attribute 63702, 'E'
    assert_equal 4, attrs.size
    bom = attrs.find{|a| a[:sku]==49256}
    ints = bom[:interchanges]
    assert ints.find{|i| i[:id]==63381}
    assert_equal "3-B-4955", bom[:part_number]
  end


  def test_bom_read
    reader = BomReader.new @service_configuration
    boms =reader.get_attribute 840
    assert boms
    assert_equal 5, boms.size
    boms =reader.get_attribute 6583
    assert boms
    dups = boms.select {|b| b["partId"]=="48145"}
    assert_equal 2, dups.size
  end

  def test_error
    setter = BomSetter.new @redis_cache, @service_configuration
    ids = [75305,75306,75307,75308,75329,75330,75331,75332,75333,75334,75335,75336,75337,75338,75339,75340]
    ids.each{|id| setter.set_bom_attribute id}
  end

  def get_part_by_sku attrs, sku
    attrs.find {|a| a[:sku] == sku}
  end

end