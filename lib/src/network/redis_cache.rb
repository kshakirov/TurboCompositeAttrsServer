class RedisCache
  private
  def parse_response response
    if not response.nil? and not response == 'null'
      JSON.parse response, {
          :symbolize_names => true
      }
    end
  end

  def parse_m_response m_response
    parsed = m_response.map do |mr|
      parse_response mr
    end
    parsed.compact
  end

  def prep_mget_keys keys, attr
    keys.map{|key| "#{key}_#{attr}"}
  end

  public
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
    rescue StandardError => e
      puts "Problems with getting response for product [#{sku}]"
      false
    end
  end


  def mget_cached_response skus, attr
    keys = prep_mget_keys skus, attr
    begin
      m_response = @redis_cache.mget(keys)
      parse_m_response(m_response)
    rescue StandardError => e
      puts "Problems with getting response"
    end
  end

  def set_cached_response sku, attr, response
    key = sku.to_s + '_' + attr.to_s
    @redis_cache.set(key, response.to_json)
  end
end