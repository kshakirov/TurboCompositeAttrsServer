require_relative "test_helper"

class TestSalesNotesAttrsReader < MiniTest::Unit::TestCase
  def test_sales_note_getter
    getter = SalesNoteGetter.new
    attrs = getter.get_sales_note_attribute 16572
    assert_equal 2, attrs.size
    assert_equal 348, attrs[1][:id]
    assert_equal '03/15/2016', attrs[0][:create_date]
    assert_equal 'Left side of Audi twin turbo.' , attrs[1][:comment]
  end

  def test_sales_note_setter
    setter = SalesNoteSetter.new
    setter.set_sales_note_attribute 16572
  end

end