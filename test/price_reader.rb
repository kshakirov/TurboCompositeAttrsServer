require_relative "test_helper"

class TestProductsAttrsReader < MiniTest::Unit::TestCase
  def test_price_reader
    @price_reader = PriceAttrReader.new
    prices = @price_reader.get_attribute [4742, 6149, 6673, 6674]
    p prices

  end

end