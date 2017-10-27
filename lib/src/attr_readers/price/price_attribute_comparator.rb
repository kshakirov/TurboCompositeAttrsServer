class PriceAttributeComparator
  private
  def both_prices_exist? new_price, old_price
    new_price and old_price and
        new_price.class.name == old_price.class.name and old_price.class.name == "Hash" and
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