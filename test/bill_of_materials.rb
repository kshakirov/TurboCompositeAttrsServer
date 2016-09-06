require_relative "test_helper"

class TestBomAttrsReader < MiniTest::Unit::TestCase
   def test_bom_set
    setter = BomSetter.new
    setter.cache_bom 6392
   end

   def test_bom_get
     getter = BomGetter.new
     attrs = getter.get_bom_attribute 6392,  'sVrXIqos994v0pkehHI28Q=='
     refute_nil attrs
     result = attrs.select {|attr| attr[:sku] == 46622}
     assert_equal 2, result[0][:ti_part_sku].size
     assert_equal 1, result[0][:distance]
     assert_equal 'Interchange', result[0][:type]
     assert_equal false, result[0][:has_bom]
     assert_equal 35.2, attrs[20][:prices]
   end


end