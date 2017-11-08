class ThirdAndHalfStageWorker
  include Celluloid
  def initialize redis_cache
    @application_setter = ApplicationSetter.new redis_cache
  end
  def set_attribute sku
    @application_setter.set_application_attribute sku
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end

end