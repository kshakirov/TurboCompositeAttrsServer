require_relative "test_helper"

class TestKitMatrix < MiniTest::Unit::TestCase

  def test_kit_matrix_setter
    setter = KitMatrixSetter.new
    setter.set_kit_matrix_attribute 6392
  end

  def test_kit_matrix_getter
    getter = KitMatrixGetter.new
    attrs = getter.get_kit_matrix_attribute 6392
    assert_equal 16, attrs[1].size
    assert_equal 31, attrs[0].size
    assert_equal "7-A-3330", attrs[1][15][:field]
    assert_equal 2, attrs[0]['8-A-0204'.to_sym]['7-A-3330'.to_sym]
  end
end