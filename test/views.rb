require 'minitest/autorun'
require_relative "test_helper"
require_relative "../lib/sync"

class TestM_Views < Minitest::Unit::TestCase
  def test_where_used


  end

  def test_part
    part = Part.find 6392
    refute_nil part, "Part is nil"
    assert_equal "test", part.name
  end

end