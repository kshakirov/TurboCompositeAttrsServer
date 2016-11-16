require_relative "test_helper"

class TestBomAttrsReader < MiniTest::Unit::TestCase

  def test_bom_set
    setter = BomSetter.new
    setter.set_bom_attribute 6243
    setter.set_bom_attribute 7130
    setter.set_bom_attribute 6991
    setter.set_bom_attribute 3756
    setter.set_bom_attribute 48536
    setter.set_bom_attribute 840
    setter.set_bom_attribute 6392
    end

   def test_bom_get
     getter = BomGetter.new
     attrs = getter.get_bom_attribute 6392,  'sVrXIqos994v0pkehHI28Q=='
     refute_nil attrs
     assert_equal 16,  attrs.size
     assert_equal 53.76, attrs[0][:prices]
     assert_equal 1, attrs[0][:quantity]
     attrs = getter.get_bom_attribute 840,  'sVrXIqos994v0pkehHI28Q=='
     refute_nil attrs
     attrs = getter.get_bom_attribute 3756,  'sVrXIqos994v0pkehHI28Q=='
     assert_equal 4, attrs.size
     assert_equal 3.712, attrs[3][:prices]
     assert_equal '49179-30220', attrs[0][:interchanges].first[:part_number]
     attrs = getter.get_bom_attribute 48536,  'sVrXIqos994v0pkehHI28Q=='
     assert_equal 16, attrs.size
     assert_equal '8-A-1560', attrs[6][:part_number]
   end

end