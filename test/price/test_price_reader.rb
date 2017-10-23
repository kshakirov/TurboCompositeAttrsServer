require_relative "../test_helper"

class TestProductsAttrsReader < MiniTest::Unit::TestCase

  def setup
    redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @price_reader = PriceAttrReader.new(redis_cache)
  end

  def test_price_reader
    prices = @price_reader.get_attribute [4742, 6149, 6673, 6674]
    assert_equal 4, prices.size
    assert_equal 152, prices[3][:standardPrice]
  end

  def test_rest_price
    price = @price_reader.get_rest_prices([42018])
    refute_nil price
  end
end