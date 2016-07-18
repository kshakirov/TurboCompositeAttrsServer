require_relative "test_helper"

class TestSalesNotesAttrsReader < MiniTest::Unit::TestCase
  def test_bom
    @reader = SalesNoteAttrReader.new
    attrs = @reader.get_attribute 16572
    assert_equal 2, attrs.size
    #assert_equal 1983, attrs[1][:id]

  end

end