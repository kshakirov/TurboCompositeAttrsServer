require_relative "test_helper"

class TestServiceKitsAttrsReader < MiniTest::Unit::TestCase
  def test_service_kit_setter
    setter = ServiceKitSetter.new
    setter.set_service_kit_attribute 13958
  end

  def test_service_kit_gettter
    getter = ServiceKitGetter.new
    attrs = getter.get_service_kit_attribute  13958,  'sVrXIqos994v0pkehHI28Q=='
    assert_equal 49, attrs.size
    assert_equal 42.68,   attrs.last[:prices]
  end

end