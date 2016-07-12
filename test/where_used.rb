require_relative "test_helper"

class TestProductsAttrsReader < MiniTest::Unit::TestCase
  def test_where_used
    @reader = WhereUsedAttrReader.new
    @stdreader = CompositAttrsReader.new
    attrs = @reader.get_w 49639
    @stdreader.add_standard_attrs_2_wu attrs
    assert_equal  'Cartridge', attrs[4742][:partType]
    assert_equal  'CHRA, CT10', attrs[6673][:description]
    assert_equal  117.9, attrs[6673][:prices]['E']

  end

 end