require_relative "test_helper"

class TestStdOversize < MiniTest::Unit::TestCase

  def setup
    @std_oversize_reader = StandardOversizeAttrReader.new
    @std_oversize_setter = StandardOversizeSetter.new
    @std_oversize_getter = StandardOversizeGetter.new
  end

  def test_jornal_bearing
    parts = @std_oversize_reader.get_attribute(45523)
    refute_nil parts
  end

  def test_jornal_bearing_spacer
    parts = @std_oversize_reader.get_attribute(45487)
    refute_nil parts
  end

  def test_setter_getter
    @std_oversize_setter.set_std_oversize_attribute(45523)
    attr = @std_oversize_getter.get_standard_oversize 45523
    p attr
  end

end