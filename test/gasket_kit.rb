require_relative "test_helper"

class TestGasketKit < MiniTest::Unit::TestCase
  def setup
    @gasket_kit_reader = GasketKitReader.new
    @gasket_kit_setter = GasketKitSetter.new
    @gasket_kit_getter = GasketKitGetter.new
  end

  # def test_gasket_getter
  #   turbos = @gasket_kit_reader.get_attribute 69079
  #   refute_nil turbos
  # end
  #
  def test_gasket_kit_setter
    cached = @gasket_kit_setter.set_gasket_kit_attribute 69079
    refute_nil cached
  end

  # def test_gasket_kit_getter
  #   turbos =  @gasket_kit_getter.get_gasket_kit_attribute 69079, '4mA2wAME2WZ1J4kWsUyi9w=='
  #   refute_nil turbos
  # end

  # def test_reader
  #   kits = @gasket_kit_reader.get_attribute(69079)
  #   refute_nil kits
  # end


end