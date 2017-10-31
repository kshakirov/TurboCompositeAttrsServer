class RedisCache

  def initialize redis_client
    @redis_cache = redis_client
  end

  def get_cached_response sku, attr
    key = sku.to_s + '_' + attr.to_s
    begin
      response = @redis_cache.get(key)
      if response
        if response != 'null'
          JSON.parse response, {:symbolize_names => true}
        else
          nil
        end
      else
        false
      end
    rescue Exception => e
      puts "Problems with getting response for product [#{sku}]"
      false
    end
  end

  def set_cached_response sku, attr, response
    key = sku.to_s + '_' + attr.to_s
    @redis_cache.set(key, response.to_json)
  end
end