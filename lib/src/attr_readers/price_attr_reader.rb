class PriceAttrReader

  def initialize redis_cache = nil
    @redis_cache = redis_cache
  end

  def _get_cached_prices ids
    prices = []
    unless ids.nil?
      ids.each do |id|
        prices.push(@redis_cache.get_cached_response(id, "price"))
      end
    end
    prices
  end

  def get_attribute ids
    _get_cached_prices ids
  end

  def get_rest_prices ids
    response = JSON.
        parse(RestClient.post 'metadata.turbointernational.com:8080/magmi/prices',
                              ids.to_json, :content_type => :json, :accept => :json)
    unless response.nil?
      return response
    end
    nil
  end
end