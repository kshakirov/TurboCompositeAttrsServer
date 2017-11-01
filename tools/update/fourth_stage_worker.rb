class FourthStageWorker
  include Celluloid
  def initialize redis_cache
    @std_ovrsize_worker = StandardOversizeSetter.new redis_cache
  end
  def set_attribute sku
    @std_ovrsize_worker.set_std_oversize_attribute  sku
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end

end