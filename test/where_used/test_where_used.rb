require_relative "../test_helper"

class TestProductsAttrsReader < MiniTest::Unit::TestCase

  def setup
    @service_configuration = get_service_configuration
  end

  def test_where_used_setter
    setter = WhereUsedSetter.new @service_configuration
    setter.set_where_used_attribute 49639
    #setter.set_where_used_attribute 6242

  end

  def test_where_used_getter
    getter = WhereUsedGetter.new
    attrs = getter.get_where_used_attribute  49639,  'sVrXIqos994v0pkehHI28Q=='
    assert_equal  'Cartridge', attrs['4742'.to_sym][:partType]
    assert_equal  'CHRA, CT10', attrs['6673'.to_sym][:description]
    refute_nil attrs['6673'.to_sym][:prices]
    assert_equal  117.8, attrs['6673'.to_sym][:prices]

  end

  def test_reader
    reader = WhereUsedAttrReader.new @service_configuration
    res = reader.get_attribute  6242
    assert res.size > 0
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