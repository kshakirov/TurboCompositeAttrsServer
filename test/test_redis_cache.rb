require_relative "test_helper"

class TestDecriptor < Minitest::Unit::TestCase
  def test_main
    redis_host = get_redis_host
    redis = Redis.new(:host => redis_host, :db => 3)
    redis_cache = RedisCache.new redis
    response  = redis_cache.get_cached_response(40296,'interchanges')
    refute_nil response
  end

  def test_wrong

  end

end