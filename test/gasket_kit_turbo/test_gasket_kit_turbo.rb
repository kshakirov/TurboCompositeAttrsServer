require_relative "test_helper"

class TestGasketTurbo < MiniTest::Unit::TestCase
  def setup
    @gasket_turbo_reader = GasketTurboReader.new
    @gasket_turbo_setter = GasketTurboSetter.new
    @gasket_turbo_getter= GasketTurboGetter.new
  end

  def test_gasket_reader
    kits = @gasket_turbo_reader.get_attribute 10667
    refute_nil kits
  end

  def test_gasket_setter
    kits = @gasket_turbo_setter.set_gasket_turbo_attribute 10667
    refute_nil kits
  end

  def test_gasket_getter
    kits = @gasket_turbo_getter.get_gasket_turbo_attribute 10667,'4mA2wAME2WZ1J4kWsUyi9w=='
    refute_nil kits
  end

end