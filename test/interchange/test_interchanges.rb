require_relative "../test_helper"

class TestInterchangeAttrsReader < MiniTest::Unit::TestCase

  def setup
    @service_configuration = get_service_configuration
  end

  def test_interchange_setter
    setter = InterchangeSetter.new @service_configuration
    setter.set_interchange_attribute 6392
  end

  def test_interchange_getter
    getter = InterchangeGetter.new
    attrs = getter.get_interchange_attribute 6392
    assert_equal 4, attrs.size
    assert_equal 1983, attrs[1][:id]
  end

  def test_reader
    reader = InterchangeReader.new @service_configuration
    interchanges = reader.get_attribute(70793)
    assert  interchanges
  end


end