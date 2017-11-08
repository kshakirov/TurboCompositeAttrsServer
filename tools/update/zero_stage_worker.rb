class ZeroStageWorker
  include Celluloid
  def initialize redis_cache
    @price_setter = PriceSetter.new redis_cache
  end

  def set_attribute skus
    @price_setter.bulk_set_price_attribute skus
  end
end