class RedisCache

  def initialize redis_client
    @redis_client = redis_client
  end

  def get_cached_response sku, attr
    key = sku.to_s + '_' + attr.to_s
    response = @redis_client.get(key)
    if response
      if response != 'null'
        JSON.parse response, {:symbolize_names => true}
      else
        nil
      end
    else
      false
    end
  end

  def set_cached_response sku, attr, response
    key = sku.to_s + '_' + attr.to_s
    @redis_client.set(key, response.to_json)
  end
end