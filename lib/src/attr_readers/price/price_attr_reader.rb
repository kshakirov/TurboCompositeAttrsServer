class PriceAttrReader

  def initialize redis_cache = nil
    @redis_cache = redis_cache
  end

  private
  def _get_cached_prices ids
    prices = []
    unless ids.nil?
      ids.each do |id|
        prices.push(@redis_cache.get_cached_response(id, "price"))
      end
    end
    prices
  end

  public
  def get_price id
    @redis_cache.get_cached_response(id, "price")
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

class PriceAttributeComparator
  private
  def both_prices_exist? new_price, old_price
    new_price and old_price and
        new_price.class.name == old_price.class.name and  old_price.class.name  == "Hash" and
        new_price.key? 'standardPrice' and old_price.key? :standardPrice
  end

  def new_price_only? new_price, old_price
    new_price and not old_price and
        new_price.class.name == "Hash" and
        new_price.key? 'standardPrice'
  end

  def _p_equal? new_price, old_price
    if both_prices_exist?(new_price, old_price)
      new_price['standardPrice'] == old_price[:standardPrice]
    elsif new_price_only?(new_price, old_price)
      new_price['standardPrice'].nil?
    end
  end

  public
  def p_equal? new_price, old_price
    _p_equal?(new_price, old_price)
  end

end