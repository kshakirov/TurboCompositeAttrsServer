class SecondaryAttributeWorker
  include Celluloid
  def initialize
    @kit_matrix_setter = KitMatrixSetter.new
    @gasket_kit_setter = GasketKitSetter.new
  end
  def set_attribute sku
    @kit_matrix_setter.set_kit_matrix_attribute  sku
    @gasket_kit_setter.set_gasket_kit_attribute sku
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end

end