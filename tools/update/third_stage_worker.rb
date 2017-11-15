class ThirdStageWorker
  include Celluloid
  def initialize redis_cache
    @kit_matrix_setter = KitMatrixSetter.new redis_cache
    @gasket_turbo_setter = GasketTurboSetter.new redis_cache
  end
  def set_attribute sku
    @kit_matrix_setter.set_kit_matrix_attribute  sku
    @gasket_turbo_setter.set_gasket_turbo_attribute sku
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end

end