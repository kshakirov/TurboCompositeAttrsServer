require_relative "test_helper"

class TestProductsAttrsReader < MiniTest::Unit::TestCase
  def test_price_reader
    redis_cache = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    price_reader = PriceAttrReader.new(redis_cache)
    prices = price_reader.get_attribute  [4742, 6149, 6673, 6674]
    assert_equal 4, prices.size
    assert_equal 152,  prices[3][:standardPrice]
  end
end