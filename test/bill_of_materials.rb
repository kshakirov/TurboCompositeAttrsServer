require_relative "test_helper"

class TestBomAttrsReader < MiniTest::Unit::TestCase
  def test_bom
    @reader = BillOfMaterialsAttrReader.new
    attrs = @reader.get_attribute 6392
    p attrs
    result = attrs.select {|attr| attr[:sku] == 46622}
    assert_equal 2, result[0][:ti_part_sku].size
    assert_equal 1, result[0][:distance]
    assert_equal 'Interchange', result[0][:type]
    assert_equal false, result[0][:has_bom]


  end

end