require_relative "../test_helper"

class TestProductsAttrsReader < MiniTest::Unit::TestCase

  def setup
    redis_host =  get_redis_host
    redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
    @price_getter = PriceAttrReader.new
    @price_setter = PriceSetter.new redis_cache
  end

  def test_price_reader
    prices = @price_getter.get_rest_prices [4742, 6149, 6673, 6674]
    assert_equal 4, prices.size
    assert_equal 152, prices[3]['standardPrice']
  end

  def test_price_setter
    skus  =[6392, 6243,7130,6991,6991,3756,48536,840]
    @price_setter.bulk_set_price_attribute skus
  end

  def test_price_getter

  end

end