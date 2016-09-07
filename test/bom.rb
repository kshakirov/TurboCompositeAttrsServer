require_relative "test_helper"

class TestBomAttrsReader < MiniTest::Unit::TestCase

  def test_bom_set
    setter = BomSetter.new
    setter.set_bom_attribute 6392
   end

   def test_bom_get
     getter = BomGetter.new
     attrs = getter.get_bom_attribute 6392,  'sVrXIqos994v0pkehHI28Q=='
     refute_nil attrs
     assert_equal 17,  attrs.size
     assert_equal 53.76, attrs[0][:prices]
     assert_equal 2, attrs[0][:interchanges].size
     assert_equal 1, attrs[0][:quantity]

   end


end