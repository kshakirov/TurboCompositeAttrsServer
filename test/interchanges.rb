require_relative "test_helper"

class TestInterchangeAttrsReader < MiniTest::Unit::TestCase

  def test_interchange_setter
    setter = InterchangeSetter.new
    setter.set_interchange_attribute 6392
  end

  def test_interchange_getter
    getter = InterchangeGetter.new
    attrs = getter.get_interchange_attribute 6392
    assert_equal 4, attrs.size
    assert_equal 1983, attrs[1][:id]
  end
end