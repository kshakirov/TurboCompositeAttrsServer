class ThirdStageWorker
  include Celluloid
  def initialize redis_cache
    @kit_matrix_setter = KitMatrixSetter.new redis_cache
    @application_setter = ApplicationSetter.new redis_cache
  end
  def set_attribute sku
    @kit_matrix_setter.set_kit_matrix_attribute  sku
    @application_setter.set_application_attribute sku
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end

end