class SecondAndHalfStageWorker
  include Celluloid
  def initialize redis_cache
    @service_kit_worker = ServiceKitSetter.new redis_cache
  end
  def set_attribute sku
    @service_kit_worker.set_service_kit_attribute sku
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end

end