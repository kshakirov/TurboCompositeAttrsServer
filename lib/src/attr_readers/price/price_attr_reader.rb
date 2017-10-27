class PriceAttrReader

  def initialize redis_cache
    @redis_cache = redis_cache
    @pricer_rest_service = 'timms.turbointernational.com:8080/magmi/prices'
  end

  def get_price id
    @redis_cache.get_cached_response(id, "price")
  end

  def get_attribute ids
    ids.map do |id|
      @redis_cache.get_cached_response(id, "price")
    end
  end

  def get_rest_prices ids
    JSON.parse(RestClient.post @pricer_rest_service,
                               ids.to_json,
                               :content_type => :json, :accept => :json)
  end
end