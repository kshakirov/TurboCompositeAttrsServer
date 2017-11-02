require_relative "test_helper"

class TestDecriptor < Minitest::Unit::TestCase

  def setup
    @redis_host = get_redis_host
  end

  def test_read
    @redis_cache = RedisCache.new Redis.new(:host => @redis_host, :db => 3)
    response  = redis_cache.get_cached_response(40296,'interchanges')
    refute_nil response
  end

  def test_bulk_delete
    redis = Redis.new(:host => @redis_host, :db => 3)
    keys = redis.keys("*_price")
    keys.each{|k| redis.del k}
  end

end