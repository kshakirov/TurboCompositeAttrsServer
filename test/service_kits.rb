require_relative "test_helper"

class TestServiceKitsAttrsReader < MiniTest::Unit::TestCase
  # def test_service_kits
  #   @reader = ServiceKitsAttrReader.new
  #   attrs = @reader.get_attribute 6392
  #   assert_equal 29, attrs.size
  #   result = attrs.select { |attr| attr[:sku] == 40272 }
  #   assert_equal 1, result.size
  #   assert_equal "200115-0000", result[0][:partNumber]
  #
  # end

  def test_service_kits_sp
    @reader = ServiceKitsAttrReader.new
    attrs = @reader.get_attribute 63194
    p attrs


  end

end