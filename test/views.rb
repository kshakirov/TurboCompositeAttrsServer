require 'minitest/autorun'
require_relative "test_helper"

class TestM_Views < Minitest::Unit::TestCase


  def test_part
    part = Part.find 6392
    refute_nil part, "Part is nil"
    assert_equal 6392, part.id
  end

end