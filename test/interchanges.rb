require_relative "test_helper"

class TestInterchangeAttrsReader < MiniTest::Unit::TestCase
  def test_bom
    @reader = InterchangeAttrReader.new
    attrs = @reader.get_attribute 6392
    assert_equal 2, attrs.size
    assert_equal 1983, attrs[1][:id]

  end

end