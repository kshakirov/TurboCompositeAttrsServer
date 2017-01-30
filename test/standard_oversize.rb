require_relative "test_helper"

class TestStdOversize < MiniTest::Unit::TestCase

  def setup
    @std_oversize_reader = StandardOversizeAttrReader.new
  end

  def test_one
    parts = @std_oversize_reader.get_attribute(45523)
    refute_nil parts
  end
end