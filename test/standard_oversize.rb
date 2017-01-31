require_relative "test_helper"

class TestStdOversize < MiniTest::Unit::TestCase

  def setup
    @std_oversize_reader = StandardOversizeAttrReader.new
  end

  def test_jornal_bearing
    parts = @std_oversize_reader.get_attribute(45523)
    refute_nil parts
  end

  # def test_jornal_bearing_spacer
  #   parts = @std_oversize_reader.get_attribute(45487)
  #   refute_nil parts
  # end
end